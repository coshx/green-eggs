require 'spec_helper'

describe PollsController do
  let(:poll) { FactoryGirl.create(:poll) }

  [[:get, :edit],[:put, :update],[:delete, :destroy],[:post, :remind_voters]].each do |method, action|
    describe "#{method.upcase} #{action}" do
      context "using correct owner key" do
        it "succeeds" do
          send(method, action, :id => poll.id, :owner_key => poll.owner_key)
          ["200", "302"].should include(response.code)
        end
      end

      context "using no owner key" do
        it "fails" do
          send(method, action, :id => poll.id)
          response.code.should == "404"
        end
      end

      context "using incorrect owner key" do
        it "fails" do
          send(method, action, :id => poll.id, :owner_key => poll.owner_key.reverse)
          response.code.should == "404"
        end
      end
    end
  end

  describe "reminding voters to vote" do
    it "requires 60 minutes between reminders" do
      poll = FactoryGirl.create(:poll_with_ballot)
      voter_email = poll.ballots.first.email
      unread_emails_for(voter_email).count.should == 1
      post "remind_voters", :id => poll.id, :owner_key => poll.owner_key
      response.should redirect_to poll_admin_path(:poll_id => poll.id, :owner_key => poll.owner_key)
      unread_emails_for(voter_email).count.should == 2
      Timecop.travel(55.minutes)
      post "remind_voters", :id => poll.id, :owner_key => poll.owner_key
      response.should redirect_to poll_admin_path(:poll_id => poll.id, :owner_key => poll.owner_key)
      unread_emails_for(voter_email).count.should == 2
      Timecop.travel(5.minutes)
      post "remind_voters", :id => poll.id, :owner_key => poll.owner_key
      response.should redirect_to poll_admin_path(:poll_id => poll.id, :owner_key => poll.owner_key)
      unread_emails_for(voter_email).count.should == 3
      Timecop.return
    end
  end
end
