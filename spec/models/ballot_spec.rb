require 'spec_helper'

describe Ballot do
  let(:poll_with_ballot) { Factory(:poll_with_ballot) }
  let(:ballot) { poll_with_ballot.ballots.first }

  describe "cast status" do
    context "brand new ballot" do
      it "is marked as uncast" do
        ballot.cast?.should be_false
      end
    end

    context "ballot with a choice" do
      it "is marked as cast" do
        ballot.choices << Factory.build(:choice)
        ballot.save!
        ballot.cast?.should be_true
      end
    end
  end

  it "sorts choices in priority order" do
    choice_a = Factory.build(:first_choice)
    choice_b = Factory.build(:third_choice)
    choice_c = Factory.build(:second_choice)
    ballot.choices << [choice_a, choice_b, choice_c]
    ballot.save
    ballot.choices.should == [choice_a, choice_c, choice_b]

    ballot.choices.find(choice_a.id).priority = 2
    ballot.choices.find(choice_b.id).priority = 0
    ballot.save
    
    ballot.choices.should == [choice_b, choice_c, choice_a]
  end

  it "destroys blank choices automatically" do
    blank_choice = Factory.build(:blank_choice)
    ballot.choices << blank_choice
    ballot.save
 
    ballot.choices.should_not include(blank_choice)
  end

  it "invites voter when created" do 
    new_ballot = Factory.build(:ballot)
    InviteMailer.should_receive(:invite_to_vote).with(new_ballot).and_return(OpenStruct.new(:deliver => true))
    Factory(:poll).ballots << new_ballot
  end
end
