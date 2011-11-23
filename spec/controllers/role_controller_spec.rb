require 'spec_helper'

describe RoleController do

#general thinkings: 
#                 -all actions can only be performed by an
#                  admin user, that has to be logged in
  
  #creating admin/no admin role and a user
  before(:each) do
  @user = User.create valid_attributes_user
  @role_no_admin = Role.create valid_attributes_role
  @role_no_admin.admin = false
  @role_no_admin.save
  @role_admin = Role.create valid_attributes_role
  @role_admin.admin = true
  @role_admin.save
  
  end  
  
  
      
  describe "GET 'new'" do   
      
    describe "success" do
      it "returns http success" do
        get 'new'
        response.should be_success
      end
      
      it "should provide a new role record" do
        get 'new'
        assigns(:role).should be_new_record
      end
      
      it "should only provide a new role record accessed by admin" do
        @user.role_id = @role_admin.id
        get 'new'
        assigns(:role).should be_new_record
        
        @user.role_id = @role_no_admin.id
        get 'new'
        assings(:role).should_not be_new_record
      end
      
    end  
    
  end

  describe "GET 'edit'" do
    before(:each) do
      @role = Role.create valid_attributes_role
    end
  
    it "return http success" do
      get 'edit', :id => @role
      response.should be_success
    end
    
    it "should find the right role" do
      get 'edit', :id => @role
      response.should eq(@role)
    end

  end

  describe "POST 'create'" do

    
    describe "success" do
      
      it "should make a new role" do
        expect {
          post 'create', :role => valid_attributes_role
               }.to change {Role.count }.by(1)
      
      end
      
      it "should redirect to the main page" do
      
      end
      
      it "should only be created by admin users" do
        @user.role_id = @role_admin
        expect {
          post 'create', :role => valid_attributes_role
               }.to change {Role.count }.by(1)
        
        @user.role_id = @role_no_admin
        expect {
          post 'create', :role => valid_attributes_role}.to_not change {Role.count }
               
      end
    end
    
    describe "failure" do
    
      it "should not make a new role" do
        expect {
          post 'create', :role => nil
               }.not_to change {Role.count}
      end
      
      it "should render the 'new' page" do
        post 'create', :role => nil
        response.should render_template('role/new')
      end
    end
  end

  describe "GET 'update'" do
    it "returns http success" do
      get 'update'
      response.should be_success
    end
    
    it "should only be updated by logged in users" do
    
    end
    
    it "should only be updated by admin users" do
    
    end
  end

  describe "delete 'destroy'" do
    it "returns http success" do
      delete 'destroy'
      response.should be_success
    end
    
    it "should only be deleted by logged in users" do
    
    end
    
    it "should only be deleted by admin users" do
    
    end
  end
  
  describe "authentication" do
    before(:each) do
      @role = Role.create valid_role_attributes
    end
    
    describe "testing non-signed-in users" do
      it "should deny access to 'new'" do
        get 'new'
        response.should redirect_to(signin_path)
      end
      
      it "should deny access to 'edit'" do
        get 'edit', :id => @role
        response.should redirect_to(signin_path)
      end
      
      it "should deny access to 'create'" do
        post 'create', :role => valid_attributes_role
        response.should redirect_to(signin_path)
      end
      
      it "should deny access to 'update'" do
        put 'update', :id => @role, :role => valid_attributes_role
        response.should redirect_to(signin_path)      
      end
      
      it "should deny access to 'destroy'" do
        delete 'destroy', :id => @role
        response.should redirect_to(signin_path)
      end
    end
    
    # signed-in-user tests...

  end

end
