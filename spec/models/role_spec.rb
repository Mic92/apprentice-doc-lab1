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

describe Role do



  
  it "should create a new instance with valid attributes" do
    Role.create! valid_attributes_role
  end  
  
  describe "user associations" do
    before(:each) do
      @role = Role.create(@attributes)
      @user1 = @role.users.create valid_attributes_user
      @user2 = @role.users.create valid_attributes_user
    end
    
    it "should have an users attribute" do
      @role.should respond_to(:users)
    end
    
    it "should have the right associated report entries" do
      @role.users.should eq([ @user1, @user2])
    
    end
    
    it "should not destroy its users when destroyed itself" do
      @user_count = User.all.length
      @role.destroy
      @user_count.should eq(User.all.length)
      
    end
   
      
    # further association tests..

   end
   
   
   describe "validations" do
   
    before(:each) do
        @attributes = valid_attributes_role
    end

    it "should require attribute level" do
      @attributes.delete(:level)
      Role.new(@attributes).should_not be_valid
    end
    
    it "should require attribute name" do
      @attributes.delete(:name)
      Role.new(@attributes).should_not be_valid
    end
    
    it "should require attribute read" do
      @attributes.delete(:read)
      Role.new(@attributes).should_not be_valid
    end
    
    it "should require attribute commit" do
      @attributes.delete(:commit)
      Role.new(@attributes).should_not be_valid
    end
    
    it "should require attribute export" do
      @attributes.delete(:export)
      Role.new(@attributes).should_not be_valid
    end
    
    it "should require attribute check" do
      @attributes.delete(:check)
      Role.new(@attributes).should_not be_valid
    end
    
    it "should require attribute modify" do
      @attributes.delete(:modify)
      Role.new(@attributes).should_not be_valid
    end
    
    it "should require attribute admin" do
      @attributes.delete(:admin)
      Role.new(@attributes).should_not be_valid
    end
    
    it "should require a unique name" do
      Role.create(@attributes)
      Role.new(@attributes).should_not be_valid
    end
    
    it "should require a unique level" do
      Role.create(@attributes)
      Role.new(@attributes).should_not be_valid
    end
    
    
    
    

   end  
end
