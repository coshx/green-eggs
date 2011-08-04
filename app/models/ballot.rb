class Ballot
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :email, :type => String

  embedded_in :poll
end
