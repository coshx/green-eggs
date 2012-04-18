class Ballot
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, :type => String
  field :cast, :type => Boolean, :default => false
  field :key, :type => String
  index :key

  embeds_many :choices
  embedded_in :poll
  accepts_nested_attributes_for :choices
  before_validation :generate_key
  after_update :destroy_blank_choices, :ensure_one_choice, :sort_by_priority
  before_update :mark_as_cast
  validates_presence_of :key
  validates_uniqueness_of :key

  set_callback(:create, :after) do |ballot|
    InviteMailer.invite_to_vote(ballot).deliver
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

  private

  def destroy_blank_choices
     self.cast = true
     self.choices.where(:original => "").destroy_all
  end

  def ensure_one_choice
     self.choices.create if self.choices.size == 0
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
