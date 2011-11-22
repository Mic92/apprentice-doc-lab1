# encoding: utf-8
#
# Copyright (C) 2011, 
# Marcus Hänsch <haensch.marcus@gmail.com> and 
# Sascha Peukert <sascha.peukert@gmail.com>
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
      @report1 = Report.create valid_attributes_report
      @report1.user_id = @user.id
      @report1.save
      
      @report2 = Report.create valid_attributes_report
      @report2.user_id = @user.id
      @report2.save
    end
    
    it "should have an existing report attribute" do
      @user.should respond_to(:reports)
      
    end
    
    it "should have the right associated reports" do
      @user.reports.should eq([ @report1, @report2 ])
      
    end
    
  end
  
  describe "role associations" do
    before(:each) do
      @role = Role.create valid_attributes_role
      @user = @role.users.create valid_attributes_user
    end
    
    it "should have an existing role attribute" do
      @user.should respond_to(:role)
    end
    
    it "should have the right associated role" do
      @user.role.should eq(@role)
    end
    
  
  end
  
  describe "business associations" do
    before(:each) do
      @busi = Business.create valid_attributes_business
      @user = @busi.users.create valid_attributes_user
    end
    
    it "should have an existing business attribute" do
      @user.should respond_to(:business)
    
    end
    
    
    it "should have the right associated business" do
      @user.business.should eq(@busi)
    end
    
  end
  
  
  describe "apprentice/instructor associations" do
    before(:each) do
      @user1 = User.create valid_attributes_user
      @user2 = User.create valid_attributes_user
      @user2.instructor_id = @user1.id
      @user2.save
      @user3 = User.create valid_attributes_user
      @user3.instructor_id = @user1.id
      @user3.save
    end
    
    it "should have an existing apprentices attribute" do
      @user1.should respond_to(:apprentices)
    end
    
    it "should have the right associated apprentices" do
      @user1.apprentices.should eq([@user2, @user3])
    end
    it "should have an existing attribute instructor" do
      @user2.should respond_to(:instructor)
      @user3.should respond_to(:instructor)
    end
    
    it "should have the same instructor attribute" do
      @user2.instructor.should eq(@user3.instructor)
    end
  end
  
  describe "validations" do
  
    before(:each) do
      @attr = valid_attributes_user      
    end
    
    it "should require attribute forename" do
      @attr.delete(:forename)  
      User.new(@attr).should_not be_valid
    end
    
    it "should require attribute name" do
      @attr.delete(:name)  
      User.new(@attr).should_not be_valid
    end
    
    it "should require attribute email" do
      @attr.delete(:email)  
      User.new(@attr).should_not be_valid
    end
    
    it "should require attribute hashed_password" do
      @attr.delete(:hashed_password)  
      User.new(@attr).should_not be_valid
    end
    
    it "should require attribute role" do
      @attr.delete(:role)  
      User.new(@attr).should_not be_valid
    end
    
    it "should require an unique email" do
      User.create(@attr)
      User.new(@attr).should_not be_valid
    end
    
    it "should not accept an incorrect email format" do
      emails = %w[asdf@asd wasd@asd,as wasdfs asdf.was@asd.asd.ds asdf.asd@ asdf@.asd]
      emails.each do |e|
        test_user = User.new(@attr.merge(:email => e))
        test_user.should_not be_valid      
      end
    end
    
    it "should accept a correct email format" do
      emails = %w[asdf@as.df as_df@as.df as.df@as.df]
      emails.each do |e|
        test_user = User.new(@attr.merge(:email => e))
        test_user.should be_valid
      end
    end

  end
  
  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    
	it "should set the encrypted password" do
      @user.hashed_password.should_not be_blank
    end
	
	#describe "method make_salt and secure_hash(string)" do   # Spaeter unnoetig, weil dann Privat. nur zum testen
	
	#  it "should make salt" do
	#    salt = nil
	#	salt = @user.make_salt
	#	salt.should_not be_nil
	#  end
	#end
	
	describe "has_password? method" do
	  
	  it "should be true if the passwords are matching" do
        @user.has_password?(@attr[:password]).should be_true
      end    

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
	end
	
	describe "authenticate method" do

      it "should return nil on email/password mismatch" do
        wrongpassword_user = User.authenticate(@attr[:email], "wrongpassword")
        wrongpassword_user.should be_nil
      end

      it "should return nil when getting an email address with no user" do
        nonexistent_user = User.authenticate("fehler@tud.de", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
	
  end
  
end
