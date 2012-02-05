require 'spec_helper'

describe Poll do
  let(:poll) { Factory(:poll) }

  describe "custom validation for name uniqueness" do
    before(:each) { Factory(:poll, :name => "Favorite childrens books") }

    it "ignores spaces " do
      invalid_poll = Factory.build(:poll, :name => "Favorite childrens  books")
      invalid_poll.should_not be_valid
    end

    it "ignores punctuation" do
      invalid_poll = Factory.build(:poll, :name => "Favorite childrens' books")
      invalid_poll.should_not be_valid
    end
  end

  describe "owner key" do
    it "is uri-safe" do
      SecureRandom.should_receive(:urlsafe_base64).with(4).and_return("T1hF2t")
      poll # reference to instantiate
    end

    it "has > 32 bits of entropy" do
      poll.owner_key.length.should >= 6 # 64^6 > 2^32
    end
  end

  it "sends admin link when created" do
    new_poll = Factory.build(:poll)
    OwnerMailer.should_receive(:send_admin_link).with(new_poll).and_return(OpenStruct.new(:deliver => true))
    new_poll.save
  end
end
