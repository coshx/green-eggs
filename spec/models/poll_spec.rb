require 'spec_helper'

describe Poll do
  let(:poll) { Factory(:poll) }
  let(:ballot) { Factory.build(:ballot) }
  let(:ballots) {[]}

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

  describe "instant-runoff results" do

    context "there are no ballots" do
      it "returns no results" do
        poll.calculate_results.should == []
      end
    end

    context "there is one ballot" do
      before(:each) { poll.ballots << ballot }

      context "the ballot has no choices" do
        it "returns no results" do
          poll.calculate_results.should == []
        end
      end

      context "the ballot has one choice" do
        it "returns the only choice" do
          ballot.choices << Factory.build(:choice, :original => "eggs")
          poll.calculate_results.should == [{slug: "eggs", original: "eggs"}]
        end
      end

      context "the ballot has many choices" do
        it "returns the choices in order" do
          choices = [Factory.build(:choice, :original => "eggs"),
                     Factory.build(:choice, :original => "waffles"),
                     Factory.build(:choice, :original => "toast")]
          ballot.choices << choices
          poll.calculate_results.should == choices.map {|c| {:slug => c.slug, :original => c.original}}
        end
      end
    end

    context "there are several ballots" do
      before(:each) do
        3.times { ballots << Factory.build(:ballot) }
        poll.ballots << ballots
      end

      context "the ballots are all the same" do
        it "returns the choices in order" do
          choices = [Factory.build(:choice, :original => "burger"),
                     Factory.build(:choice, :original => "fries"),
                     Factory.build(:choice, :original => "shake")]
          ballots.each {|b| b.choices << choices}
          poll.calculate_results.should == choices.map {|c| {:slug => c.slug, :original => c.original}}
        end
      end

      context "the ballots share no common choices" do
        it "returns no results" do
          ballots.each do |b|
            3.times {b.choices << Factory.build(:choice)}
          end
          poll.calculate_results.should == []
        end
      end

      context "the ballots share 2 common 1st choices (only)" do
        it "returns the common choice" do
          ["apple", "blueberry", "cherry"].each do |fruit|
            ballots[0].choices << Factory.build(:choice, :original => fruit)
          end
          ["apple", "blackberry", "clementine"].each do |fruit|
            ballots[1].choices << Factory.build(:choice, :original => fruit)
          end
          ["apple", "blackcurrant", "cranberry"].each do |fruit|
            ballots[2].choices << Factory.build(:choice, :original => fruit)
          end
          poll.calculate_results.should == [{:slug => "apple", :original => "apple"}]
        end
      end

      context "the ballots share a 1st choice and 3rd choice in common (only)" do
        it "returns the common choice" do
          ["apple", "blueberry", "cherry"].each do |fruit|
            ballots[0].choices << Factory.build(:choice, :original => fruit)
          end
          ["clementine", "blackberry", "apple"].each do |fruit|
            ballots[1].choices << Factory.build(:choice, :original => fruit)
          end
          ["apricot", "blackcurrant", "cranberry"].each do |fruit|
            ballots[2].choices << Factory.build(:choice, :original => fruit)
          end
          poll.calculate_results.should == [{:slug => "apple", :original => "apple"}]
        end
      end

      context "the ballots share a 2nd choice and 3rd choice in common (only)" do
        it "returns the common choice" do
          ["apple", "blueberry", "cherry"].each do |fruit|
            ballots[0].choices << Factory.build(:choice, :original => fruit)
          end
          ["clementine", "blackberry", "blueberry"].each do |fruit|
            ballots[1].choices << Factory.build(:choice, :original => fruit)
          end
          ["apricot", "blackcurrant", "cranberry"].each do |fruit|
            ballots[2].choices << Factory.build(:choice, :original => fruit)
          end
          poll.calculate_results.should == [{:slug => "blueberry", :original => "blueberry"}]
        end
      end

      context "3 ballots share a 1st choice and 3rd choice in common and another 1st choice and 3rd choice in common" do
        it "returns the 1st choice of the ballot with both a common 1st and 3rd choice, followed that ballot's 3rd choice (which is the first choice of another ballot)" do
          ["apple", "blueberry", "cherry"].each do |fruit|
            ballots[0].choices << Factory.build(:choice, :original => fruit)
          end
          ["cranberry", "blackberry", "apple"].each do |fruit|
            ballots[1].choices << Factory.build(:choice, :original => fruit)
          end
          ["apricot", "blackcurrant", "cranberry"].each do |fruit|
            ballots[2].choices << Factory.build(:choice, :original => fruit)
          end
          poll.calculate_results.should == [{:slug => "cranberry", :original => "cranberry"}, {:slug => "apple", :original => "apple"}]
        end
      end

     context "4 ballots share a 1st choice and 3rd choice in common and another 1st choice and 3rd choice in common, each common choice on a different ballot" do
        it "returns no results" do
          poll.ballots << Factory.build(:ballot)
          ballots = poll.ballots
          ["apple", "blueberry", "cherry"].each do |fruit|
            ballots[0].choices << Factory.build(:choice, :original => fruit)
          end
          ["cranberry", "blackberry", "avocado"].each do |fruit|
            ballots[1].choices << Factory.build(:choice, :original => fruit)
          end
          ["apricot", "blackcurrant", "apple"].each do |fruit|
            ballots[2].choices << Factory.build(:choice, :original => fruit)
          end
          ["anotherfruit", "banana", "cranberry"].each do |fruit|
            ballots[3].choices << Factory.build(:choice, :original => fruit)
          end
          poll.calculate_results.should == []
        end
      end
    end
  end
end
