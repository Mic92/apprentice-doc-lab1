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

describe User do
  
  
  
  
  it "should create a new instance with given valid attributes" do
    User.create! (valid_attributes_user)
  end
  
  describe "report associations" do
    before(:each) do
      @user = User.create valid_attributes_user
      @report1 = @user.reports.create valid_attributes_report
      @report2 = @user.reports.create valid_attributes_report
    end
    
    it "should have an existing report attribute" do
      @user.should respond_to(:reports)
      
    end
    
    it "should have the right associated reports" do
      @user.reports.should eq([ @report1, @report2 ])
      
    end
    
    it "should destroy associated reports" do
      @user.destroy
      [ @report1, @report2 ].each do |report|
        Report.find_by_id(entry.id).should be_nil
      end
    end   
  
  end
  
  describe "role associations" do
    before(:each) do
      @user = User.create valid_attributes_user
      @role = @user.role.create valid_attributes_role
    end
    
    it "should have an existing role attribute" do
      @user.should respont_to(:reports)
          
    end
    
    it "should not destroy the associated role" do
      @user.destroy
      Role.find_by_id(@role.id).should_not be_nil
    end
  
  end
  
  
end
