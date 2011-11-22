require 'spec_helper'

describe Ihk do
  describe "validations" do

    before(:each) do
      @attributes = valid_attributes_ihk
    end

    it "should require attribute name" do
      @attributes.delete(:name)
      Ihk.new(@attributes).should_not be_valid
    end
  end
end
