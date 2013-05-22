class Authentication

  include Mongoid::Document
  include Mongoid::Timestamps

  field :uid, :type => Integer
  field :provider, :type => String
  field :user_id, :type => Integer

end