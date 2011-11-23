require 'spec_helper'

describe Code do
  it "should create a new instance with given valid attributes" do
      Code.create! (valid_attributes_code)
  end
        
  describe "validations" do

    before(:each) do
      @attributes = valid_attributes_code
    end

    it "should require attribute name" do
      @attributes.delete(:name)
      Code.new(@attributes).should_not be_valid
    end

    it "should require attribute code" do
      @attributes.delete(:code)
      Code.new(@attributes).should_not be_valid
    end
  end
end
