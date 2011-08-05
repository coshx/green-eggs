class Ballot
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :email, :type => String

  embeds_many :choices
  embedded_in :poll
  accepts_nested_attributes_for :choices
  after_update [:destroy_blank_choices, :ensure_one_choice]
 
  set_callback(:create, :after) do |ballot|
    InviteMailer.invite_to_vote(ballot).deliver
  end

  def update_attributes(attributes)
    super(attributes)
  end

  protected

  def destroy_blank_choices
     self.choices.where(:original => "").destroy_all
  end
  
  def ensure_one_choice
     self.choices.create if self.choices.size == 0
  end

end
