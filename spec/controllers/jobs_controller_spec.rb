require 'spec_helper'

describe JobsController do
  before(:each) do
    @admin = User.create valid_attributes_user
    @role = Role.create valid_attributes_role_admin
    @role.users << @admin
    @job = Job.create valid_attributes_job
  end
  
  describe "method tests for signed in admin" do
    before(:each) do
      test_sign_in(@admin)
    end

    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end
    end

    describe "GET 'show'" do
      it "returns http success" do
        get 'show', :id => @job
        response.should be_success
      end
    end

    describe "GET 'edit'" do
      it "returns http success" do
        get 'edit', :id => @job
        response.should be_success
      end
    end
  end
end
