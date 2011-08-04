class Choice
  include Mongoid::Document
  include Mongoid::Timestamps
  field :original, :type => String
  field :priority, :type => Integer

  embedded_in :ballot
end
