require 'spec_helper'

describe Ballot do
  let(:poll_with_ballot) { FactoryGirl.create(:poll_with_ballot) }
  let(:ballot) { poll_with_ballot.ballots.first }

  describe "cast status" do
    context "brand new ballot" do
      it "is marked as uncast" do
        ballot.cast?.should be_false
      end
    end

    context "ballot with a choice" do
      it "is marked as cast" do
        ballot.choices << FactoryGirl.build(:choice)
        ballot.save!
        ballot.cast?.should be_true
      end
    end
  end

  it "sorts choices in priority order" do
    choice_a = FactoryGirl.build(:first_choice)
    choice_b = FactoryGirl.build(:third_choice)
    choice_c = FactoryGirl.build(:second_choice)
    ballot.choices << [choice_a, choice_b, choice_c]
    ballot.save!
    ballot.choices.should == [choice_a, choice_c, choice_b]

    ballot.choices.find(choice_a.id).priority = 2
    ballot.choices.find(choice_b.id).priority = 0
    ballot.save

    ballot.choices.should == [choice_b, choice_c, choice_a]
  end

  it "destroys blank choices automatically" do
    blank_choice = FactoryGirl.build(:blank_choice)
    ballot.choices << blank_choice
    ballot.save

    ballot.choices.should_not include(blank_choice)
  end

  it "invites voter when created" do
    poll = FactoryGirl.create(:poll)
    new_ballot = poll.ballots.new(:email => "samson@example.com")
    InviteMailer.should_receive(:invite_to_vote).with(new_ballot).and_return(OpenStruct.new(:deliver => true))
    new_ballot.save!
  end

  describe "key" do
    it "is uri-safe" do
      # two keys will be created: 1 for the poll owner and 1 for the ballot
      SecureRandom.should_receive(:urlsafe_base64).twice.with(4).and_return("T1hF2t")
      ballot # reference to instantiate
    end

    it "has > 32 bits of entropy" do
      ballot.key.length.should >= 6 # 64^6 > 2^32
    end
  end

  describe "after_update" do
    subject { FactoryGirl.build_stubbed :ballot, :poll => FactoryGirl.build_stubbed(:poll) }

    it "publishes to firehose" do
      Firehose::Producer.should_receive(:new).and_return mock('publisher').tap { |p| p.stub_chain :publish, :to }
      subject.run_callbacks :update
    end
  end

  describe "sending reminder emails" do
    subject { FactoryGirl.build(:ballot, :poll => FactoryGirl.build_stubbed(:poll)) }

    it "sends a reminder email when it has a valid email" do
      subject.send(:generate_key) # wtf?
      subject.send_reminder_email
      unread_emails_for(subject.email).count.should == 1
    end

    it "doesn't send a reminder email when it's an anonymous ballot" do
      subject.email = "anonymous@greeneg.gs"
      subject.send_reminder_email
      unread_emails_for(subject.email).count.should == 0
    end

    it "doesn't send a reminder email when it's already been cast" do
      subject.cast = true
      subject.send_reminder_email
      unread_emails_for(subject.email).count.should == 0
    end

  end
end
