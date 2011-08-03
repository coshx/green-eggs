class Choice
  include Mongoid::Document
  include Mongoid::Timestamps
  field :priority, :type => Integer

end
