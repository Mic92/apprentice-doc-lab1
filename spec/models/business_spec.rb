require 'spec_helper'

describe Business do
  it "should create a new instance with given valid attributes" do
      Business.create! (valid_attributes_business)
  end
  
  describe "validations" do

    before(:each) do
      @attributes = valid_attributes_business
    end

    it "should require attribute name" do
      @attributes.delete(:name)
      Business.new(@attributes).should_not be_valid
    end

    it "should require attribute zipcode" do
      @attributes.delete(:zipcode)
      Business.new(@attributes).should_not be_valid
    end

    it "should require attribute street" do
      @attributes.delete(:street)
      Business.new(@attributes).should_not be_valid
    end

    it "should require attribute city" do
      @attributes.delete(:city)
      Business.new(@attributes).should_not be_valid
    end
  end
end
