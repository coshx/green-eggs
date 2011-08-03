class Voter
  include Mongoid::Document
  include Mongoid::Timestamps
  field :email, :type => String
  field :secret, :type => String

end
