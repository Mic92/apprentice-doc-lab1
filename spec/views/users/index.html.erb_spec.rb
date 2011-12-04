# encoding: utf-8
#
# Copyright (C) 2011, Marcus Hänsch <haensch.marcus@gmail.com>
#
# This file is part of ApprenticeDocLab1, an application written for
# buschmais GbR <http://www.buschmais.de/>.
#
# ApprenticeDocLab1 is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# ApprenticeDocLab1 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with ApprenticeDocLab1.  If not, see <http://www.gnu.org/licenses/>.

require 'spec_helper'

describe "users/index.html.erb" do
  before(:each) do
    @admin_role = mock_model(Role,:name => 'admin', :admin? => true, :modify => true, :check => true)
    @instructor_role = mock_model(Role, :name => 'instructor', :check => true, :modify? => true, :admin? => false)
    @apprentice_role = mock_model(Role, :name => 'apprentice', :modify? => false, :check => false, :admin? => false)
    @apprentice = mock_model(User, :name => 'Azubi',
                             :forename => 'One',
                             :role  => @apprentice_role,
                             :deleted? => false)
    @instructor = mock_model(User, :name => 'Ausbilder',
                             :forename => 'One',
                             :role  => @instructor_role,
                             :deleted? => false)
    @admin = mock_model(User, :name => 'Admin',
                              :forename => 'One',
                              :role => @admin_role,
                              :deleted? => false)
    assign(:users, [@admin, @apprentice, @instructor])
  end
  
  describe "admin view" do
    before(:each) do
      assign(:current_user, @admin)
    end
    it "should display all users" do
      render
      rendered.should include((@admin.name), (@instructor.name), (@apprentice.name))
    end
    it "should have a link to create a new user" do
      render
      rendered.should include('href="/users/new"')
    end
    
    it "should have a link to deactivate users" do
      render
      rendered.should include("href=\"/users/#{@admin.id}\"", "href=\"/users/#{@instructor.id}\"", "href=\"/users/#{@apprentice.id}\"")
    end
  
  end
  
  describe "instructor view" do
    before(:each) do
      assign(:current_user, @instructor)
    end
    
    it "should display all its apprentices" do
      render
      rendered.should include(@apprentice.name)
    end

    it "should have a link to create a new apprentice" do
      render
      rendered.should include('href="/users/new"')
    end

    it "should have a link to deactivate apprentices" do
      render
      rendered.should include("href=\"/users/#{@apprentice.id}\"")
    end
  end
end
