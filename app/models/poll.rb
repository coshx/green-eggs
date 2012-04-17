class Poll
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, :type => String
  field :owner_email, :type => String
  field :owner_key, :type => String
  key :name

  before_create :generate_owner_key
  validate :check_for_collision, :on => :create
  validates_presence_of :name
  validates_presence_of :owner_email

  embeds_many :ballots

  set_callback(:create, :after) do |poll|
    OwnerMailer.send_admin_link(poll).deliver
  end

  def calculate_results
    eliminated_slugs = {}
    slugs_ever_seen = {}
    results = []
    while true
      first_choice_tallies = {}
      overall_tallies = {}
      ballots.each do |b|
        valid_choices = b.choices.reject {|c| eliminated_slugs[c.slug]}
        next if valid_choices.empty?
        first_choice = valid_choices.first
        first_choice_tallies[first_choice.slug] ||= 0
        first_choice_tallies[first_choice.slug] += 1
        valid_choices.each do |c|
          overall_tallies[c.slug] ||= 0
          overall_tallies[c.slug] += 1
          slugs_ever_seen[c.slug] = c.original
        end
      end
      most_first_choice_votes = first_choice_tallies.values.max
      choices_with_most_first_choice_votes = first_choice_tallies.select { |k,v| v == most_first_choice_votes }
      if choices_with_most_first_choice_votes.count == 1
        # found winner
        winner = choices_with_most_first_choice_votes.first
        results << winner
        eliminated_slugs[winner[0]] = true
      else
        # no winner yet
        fewest_votes_overall = overall_tallies.values.min
        choices_with_fewest_votes_overall = overall_tallies.select {|k,v| v == fewest_votes_overall}
        choices_with_fewest_votes_overall.each {|c| eliminated_slugs[c[0]] = true}
      end
      # has every choice either won or been eliminated?
      break if slugs_ever_seen.count == eliminated_slugs.count
    end
    # return hashes of {:slug, :display_name} in winning order
    results.map {|r| {:slug => r[0], :original => slugs_ever_seen[r[0]]}}
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
  
end
