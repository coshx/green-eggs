class Choice
  include Mongoid::Document
  include Mongoid::Timestamps
  field :priority, :type => Integer

  field :original, :type => String
  field :slug, :type => String
  field :link, :type => String

  before_save :create_slug

  embedded_in :ballot
  embedded_in :poll

  def create_slug
    if self.original
      self.slug = self.original.downcase.gsub(/[^a-z0-9]+/, '')
    end
  end

end
