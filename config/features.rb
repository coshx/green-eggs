# Feature flips
condition :under_development, Rails.env.development?

feature :real_time do
  active?(:under_development) || ENV['firehose_uri'].present?
end
