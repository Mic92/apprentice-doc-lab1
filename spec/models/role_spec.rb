require 'spec_helper'

describe Role do


  before(:each) do
    @user = User.create valid_attributes_user
  end
  
  it "should create a new instance with valid attributes" do
    @user.role.create! valid_attributes_role
  end  
  
  describe "role associations" do
    before(:each) do
      @role = @user.role.create valid_attributes_role
    end
    
    it "should be associated with one user" do
      @user.should respond_to(:role)
    end
    
      
# further association tests..

   end
   
   describe "validations" do
    before(:each) do
      @attributes = valid_attributes_role
    end
    it "should require a level"
      @attributes.delete(:level)
      @user.role.(new(@attributes).should_not be_valid
    end
    
    it "should require a name"
      @attributes.delete(:name)
      @user.role.(new(@attribues).should_not be_valid
    end
    
    it "should have valid attribute read"
      @attributes.delete(:read)
      @user.role.(new(@attributes).should_not be_valid
    end
    
    it "should have valid attribute commit"
      @attributes.delete(:commit)
      @user.role.(new(@attributes).should_not be_valid
    end
    
    it "should have valid attribute export"
      @attributes.delete(:export)
      @user.role.(new(@attributes).should_not be_valid
    end
    
    it "should have valid attribute check"
      @attributes.delete(:check)
      @user.role.(new(@attributes).should_not be_valid
    end
    
    it "should have valid attribute modify"
      @attributes.delete(:modify)
      @user.role.(new(@attributes).should_not be_valid
    end
    
    it "should have valid attribute admin"
      @attributes.delete(:admin)
      @user.role.(new(@attributes).should_not be_valid
    end  
   end
    
    
    
    
  
end
