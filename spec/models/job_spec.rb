require 'spec_helper'

describe Job do
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
