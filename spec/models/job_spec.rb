require 'spec_helper'

describe Job do
  it "should create a new instance with given valid attributes" do
    Job.create! (valid_attributes_job)
  end
        
  describe "validations" do

    before(:each) do
      @attributes = valid_attributes_job
    end

    it "should require attribute name" do
      @attributes.delete(:name)
      Job.new(@attributes).should_not be_valid
    end
  end
end
