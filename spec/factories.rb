Factory.define :poll do |p|
  p.name "What to order for Friday lunch?"
  p.owner_email "stewie@example.com"
end

Factory.define :poll_with_ballot, :parent => :poll do |p|
  p.after_create do |poll|
    ballot = Factory.build(:ballot)
    poll.ballots << ballot
  end
end

Factory.define :ballot do |b|
  b.email "sonia@example.com"
end

Factory.define :choice do |c|
  c.original "CHINESE!!!"
  c.priority 0
end

Factory.define :first_choice, :parent => :choice do |c|
end

Factory.define :second_choice, :parent => :choice do |c|
  c.original "General TSO"
  c.priority 1
end

Factory.define :third_choice, :parent => :choice do |c|
  c.original "Chicken"
  c.priority 2
end

Factory.define :blank_choice, :parent => :choice do |c|
  c.original ""
end
