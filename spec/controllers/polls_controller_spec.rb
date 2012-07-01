require 'spec_helper'

describe PollsController do
 let(:poll) { FactoryGirl.create(:poll) }

  [[:get, :edit],[:put, :update],[:delete, :destroy]].each do |method, action|
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
end
