require 'spec_helper'

describe SessionsController do
  
  before(:each) do
    @user = User.create valid_attributes_user
  end
  
  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      get 'create', :email => @user.email, :password => @user.password, :session => { :password => @user.password, :email => @user.email }
      response.should redirect_to(welcome_path)
    end
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      test_sign_in(@user)
      post 'destroy'
      response.should redirect_to(root_path)
    end
  end

end
