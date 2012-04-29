FactoryGirl.define do

factory :poll do |p|
  p.name "What to order for Friday lunch?"
  p.owner_email "stewie@example.com"
end

factory :poll_with_ballot, :parent => :poll do |p|
  p.after_create do |poll|
    ballot = FactoryGirl.build(:ballot)
    poll.ballots << ballot
  end
end

factory :ballot do |b|
  b.email "sonia@example.com"
end

factory :choice do |c|
  c.sequence(:original) {|i| "unique_choice_#{i}"}
end

factory :first_choice, :parent => :choice do |c|
  c.priority 0
end

factory :second_choice, :parent => :choice do |c|
  c.priority 1
end

factory :third_choice, :parent => :choice do |c|
  c.priority 2
end

factory :blank_choice, :parent => :choice do |c|
  c.original ""
end

end
