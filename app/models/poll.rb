class Poll
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, :type => String
  field :owner_email, :type => String
  field :owner_key, :type => String
  field :invitation_key, :type => String
  key :name

  before_create :generate_owner_key
  after_update :destroy_blank_choices
  after_update :save_choices
  validate :check_for_collision, :on => :create
  validates_presence_of :name
  validates_presence_of :owner_email

  embeds_many :ballots
  embeds_many :choices
  accepts_nested_attributes_for :choices

  set_callback(:create, :after) do |poll|
    OwnerMailer.send_admin_link(poll).deliver
  end

  def calculate_irv
    eliminated_slugs = {}
    slugs_ever_seen = {}
    results = []
    round = 0
    log = ""
    while true
      round += 1
      log += "Beginning round ##{round}\n"
      first_choice_tallies = {}
      overall_tallies = {}
      num_valid_ballots = 0
      ballots.each do |b|
        valid_choices = b.choices.reject {|c| eliminated_slugs[c.slug]}
        next if valid_choices.empty?
        first_choice = valid_choices.first
        first_choice_tallies[first_choice.slug] ||= 0
        first_choice_tallies[first_choice.slug] += 1
        num_valid_ballots += 1 if valid_choices.present?
        valid_choices.each do |c|
          overall_tallies[c.slug] ||= 0
          overall_tallies[c.slug] += 1
          slugs_ever_seen[c.slug] = c.original
        end
      end
      break if first_choice_tallies.empty?
      most_first_choice_votes = first_choice_tallies.values.max
      choices_with_most_first_choice_votes = first_choice_tallies.select { |k,v| v == most_first_choice_votes }
      pct = first_choice_tallies[choices_with_most_first_choice_votes.first[0]].to_f / num_valid_ballots
      if pct > 0.50
        # found a winner
        winner = choices_with_most_first_choice_votes.first
        log += "#{winner[0]} has > 50% of 1st-choice votes (#{most_first_choice_votes}/#{num_valid_ballots}=#{(pct*100).to_i}%), wins #{(results.count + 1).ordinalize} place\n"
        results << winner
        eliminated_slugs[winner[0]] = true
      else
        log += "#{(pct*100).to_i}% of 1st-choice votes for #{choices_with_most_first_choice_votes.keys.join(",")}; no winner this round\n"
        # no winner yet
        fewest_votes_overall = overall_tallies.values.min
        choices_with_fewest_votes_overall = overall_tallies.select {|k,v| v == fewest_votes_overall}
        choices_with_fewest_votes_overall.each {|c| eliminated_slugs[c[0]] = true}
        if choices_with_fewest_votes_overall.count == 1
          log += "#{choices_with_fewest_votes_overall.first.key} has fewest votes overall (#{fewest_votes_overall}), eliminated\n"
        else
          log += "#{choices_with_fewest_votes_overall.keys.join(",")} tie for fewest votes overall (#{fewest_votes_overall}), eliminated\n"
        end
      end

      log += "\n"
      # has every choice either won or been eliminated?
      break if slugs_ever_seen.count == eliminated_slugs.count
    end
    log += "Done."
    # return results hashes of {:slug, :display_name} in winning order, along with log
    {:winners => results.map {|r| {:slug => r[0], :original => slugs_ever_seen[r[0]]}}, :log => log}
  end

  def calculate_borda

    results = {}

    ballots.each do |b|
      num_choices = b.choices.size
      ballot_handicap = num_choices.to_f / (1..num_choices).sum
      b.choices.each do |c|
        if c.slug
          results[c.slug] ||= {}
          results[c.slug][:original] ||= c.original
          results[c.slug][:tally] ||= 0.0
          results[c.slug][:tally] += (((num_choices - c.priority) / num_choices.to_f) * ballot_handicap) / ballots.count
        end
      end
    end
   results.map {|k,v| v}.sort {|x,y| y[:tally] <=> x[:tally]}
  end

  def generate_invitation_key
    self.invitation_key = SecureRandom.urlsafe_base64(4)
  end

  private

  def generate_owner_key
    self.owner_key = SecureRandom.urlsafe_base64(4)
  end

  # validate uniqueness of key
  def check_for_collision
    canonical_id = name.identify
    polls = Poll.all(:conditions => {:id => canonical_id})
    if polls.count > 0
      errors.add(:base, "Name too similar to that of an existing poll")
    end
  end

  def destroy_blank_choices
    self.choices.where(:original => "").destroy_all
  end

  def save_choices
    self.choices.each {|c| c.save}
  end
end
