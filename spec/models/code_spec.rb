require 'spec_helper'

describe Code do
  describe "validations" do

    before(:each) do
      @attributes = valid_attributes_code
    end

    it "should require attribute code" do
      @attributes.delete(:code)
      Code.new(@attributes).should_not be_valid
    end
  end
end
