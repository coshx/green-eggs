class Ballot
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :email, :type => String
  field :secret_key, :type => String
end
