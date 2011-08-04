class Choice
  include Mongoid::Document
  include Mongoid::Timestamps
  field :priority, :type => Integer
  
  has_one :tag

  embedded_in :ballot
end
