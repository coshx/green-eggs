require 'spec_helper'

describe BallotsController do
  let(:poll) { FactoryGirl.create(:poll_with_ballot) }
  let(:group_poll) { FactoryGirl.create(:poll_with_invitation_key) }
  let(:ballot) { poll.ballots.first }

  [[:get, :edit],[:put, :update],[:get, :show]].each do |method, action|
    describe "#{method.upcase} #{action}" do
      context "using correct ballot key" do
        it "succeeds" do
          send(method, action, :poll_id => poll.id, 
               :ballot_key => ballot.key)
          ["200", "302"].should include(response.code)
        end
      end

      context "using no ballot key" do
        it "fails" do
          send(method, action, :poll_id => poll.id)
          response.code.should == "404"
        end
      end

      context "using incorrect ballot key" do
        it "fails" do
          send(method, action, :poll_id => poll.id, 
               :ballot_key => ballot.key.reverse)
          response.code.should == "404"
        end
      end
    end 
  end


  context "using poll invitation key" do
    describe "GET show" do
      it "succeeds" do
        get :show, :poll_id => group_poll.id, :ballot_key => group_poll.invitation_key
        response.should be_success
      end
    end
  end
  
end