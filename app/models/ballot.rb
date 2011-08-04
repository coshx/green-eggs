class Ballot
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :email, :type => String

  embeds_many :choices
  embedded_in :poll
  accepts_nested_attributes_for :choices
 
  set_callback(:create, :after) do |ballot|
    InviteMailer.invite_to_vote(ballot).deliver
  end

  def update_attributes(attributes)
    super(attributes)
  end
end
