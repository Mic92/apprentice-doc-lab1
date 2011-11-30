require 'spec_helper'

describe "users/index.html.erb" do
  before(:each) do
    @admin_role = mock_model(Role, :admin? => true)
    @instructor_role = mock_model(Role, :check? => true, :admin? => false)
    @apprentice_role = mock_model(Role, :check? => false, :admin? => false)
    @apprentice = mock_model(User, :name => 'Azubi',
                             :forename => 'One',
                             :role  => @apprentice_role)
    @instructor = mock_model(User, :name => 'Ausbilder',
                             :forename => 'One',
                             :role  => @instructor_role)
    @admin = mock_model(User, :name => 'Admin',
                              :forename => 'One',
                              :role => @admin_role)
  end
  
  describe "admin view" do
    before(:each) do
      assign(:current_user, @admin)
    end
    it "should display all users" do
      render
      rendered.should include((l @admin.name), (l @instructor.name), (l @apprentice.name))
    end
    it "should have a link to create a new user" do
      render
      rendered.should include('href="/users/new"')
    end
    
    it "should have a link to deactivate users" do
      rendered.should include("href=\"/users/#{@admin.id}\"", "href=\"/users/#{@instructor.id}\"", "href=\"/users/#{@apprentice.id}\"")
    end
  
  end
  
  describe "instructor view" do
    before(:each) do
      assign(:current_user, @instructor)
    end
    
    it "should display all its apprentices" do
      render
      rendered.should include(l @apprentice.name)
    end
    
    it "should NOT display instructors or admins" do
      render
      rendered.should_not include((l @admin.name), (l @instructor.name))
    end

    it "should have a link to create a new apprentice" do
      render
      rendered.should include('href="/users/new"')
    end

    it "should have a link to deactivate apprentices" do
      rendered.should include("href=\"/users/#{@apprentice.id}\"")
    end
  end
  
end
