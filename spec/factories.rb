FactoryGirl.define do

  factory :poll do
    name "What to order for Friday lunch?"
    owner_email "stewie@example.com"
  end

  factory :poll_with_ballot, :parent => :poll do
    after_create do |poll|
      ballot = FactoryGirl.build(:ballot)
      poll.ballots << ballot
    end
  end

  factory :ballot do
    email "sonia@example.com"
  end

  factory :choice do
    sequence(:original) {|i| "unique_choice_#{i}"}
  end

  factory :first_choice, :parent => :choice do
    priority 0
  end

  factory :second_choice, :parent => :choice do
    priority 1
  end

  factory :third_choice, :parent => :choice do
    priority 2
  end

  factory :blank_choice, :parent => :choice do
    original ""
  end

end
