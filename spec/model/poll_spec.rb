require 'spec_helper'

describe Poll do
  describe "custom validation for name uniqueness" do
    before(:each) { Factory(:poll, :name => "Favorite childrens books") }

    it "ignores spaces " do
      poll = Factory.build(:poll, :name => "Favorite childrens  books")
      poll.should_not be_valid
    end

    it "ignores punctuation" do
      poll = Factory.build(:poll, :name => "Favorite childrens' books")
      poll.should_not be_valid
    end
  end
end
