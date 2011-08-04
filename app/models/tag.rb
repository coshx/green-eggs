class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :original, :type => String
  key :original
  belongs_to :choice

  def self.canonicalize(raw_user_input)
    raw_user_input.identify 
  end
end
