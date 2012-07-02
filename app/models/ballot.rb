class Ballot
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, :type => String
  field :invitationMessage, :type => String
  field :cast, :type => Boolean, :default => false
  field :key, :type => String
  index :key

  embeds_many :choices
  embedded_in :poll
  accepts_nested_attributes_for :choices
  after_build :generate_key
  after_update :destroy_blank_choices, :sort_by_priority
  after_update :notify_firehose
  before_update :mark_as_cast
  validates_presence_of :key
  validates_uniqueness_of :key

  set_callback(:create, :after) do |ballot|
    InviteMailer.invite_to_vote(ballot).deliver if email_valid?
  end

  scope :outstanding, :where => {:cast => false}
  scope :cast, :where => {:cast => true}

  def update_attributes(attributes)
    super(attributes)
  end

  def sort_by_priority
    reordered_choices = self.choices.sort {|x,y| x.priority <=> y.priority }
    self.choices.clear
    reordered_choices.each { |choice| self.choices.create(choice.attributes) }
  end

  def send_reminder_email
    if !cast && email_valid?
      ReminderMailer.send_reminder(self).deliver
    end
  end

  def email_valid?
    email.present? && !email.match(/@greeneg\.gs$/) && email.match(/.+\@.+/)
  end

  private

  def destroy_blank_choices
    self.choices.where(:original => "").destroy_all
  end

  def notify_firehose
    Firehose::Producer.new(FirehoseServer.uri).publish(to_json).to "/polls/#{poll.id}"
  rescue => ex
    # allow this to fail, its not vital
    Rails.logger.warn "Error in Ballot#notify_firehose: #{ex.message}"
  end

  def mark_as_cast
    self.cast = true
  end

  def generate_key
    # if a collision, try again
    begin
      new_key = SecureRandom.urlsafe_base64(4)
    end while self.poll.ballots.where(:key => new_key).count > 0
    self.key = new_key
  end

end
