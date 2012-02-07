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
