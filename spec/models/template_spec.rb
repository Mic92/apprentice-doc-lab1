require 'spec_helper'

describe Template do
  describe "validations" do

    before(:each) do
      @attributes = valid_attributes_template
    end

    it "should require attribute name" do
      @attributes.delete(:name)
      Template.new(@attributes).should_not be_valid
    end

    it "should require attribute code_id" do
      @attributes.delete(:code_id)
      Template.new(@attributes).should_not be_valid
    end
    
    it "should require attribute job_id" do
      @attributes.delete(:job_id)
      Template.new(@attributes).should_not be_valid
    end
    
    it "should require attribute ihk_id" do
      @attributes.delete(:ihk_id)
      Template.new(@attributes).should_not be_valid
    end
  end
end
