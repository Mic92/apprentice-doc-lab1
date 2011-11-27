# encoding: utf-8
#
# Copyright (C) 2011, Dominik Cermak <d.cermak@arcor.de>
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

describe PasswordsController do
  before(:each) do
    @admin = User.create valid_attributes_user
    @admin_role = Role.create valid_attributes_role_admin
    @admin_role.users << @admin
    @user = User.create valid_attributes_user.merge(:email => 'azubi@business.de')
    @role = Role.create valid_attributes_role
    @role.users << @user
  end

  describe "PUT 'update'" do
    before(:each) do
      test_sign_in(@admin)
    end

    it "should find the right user" do
      put 'update', :id => @user
      assigns(:user).should eq(@user)
    end

    it "should generate a password with lenght 8" do
      put 'update', :id => @user
      assigns(:password).class.should eq(String)
      assigns(:password).length.should eq(8)
    end

    it "should change the user's password" do
      expect {
        put 'update', :id => @user
      }.to change { User.find(@user).hashed_password }
    end

    it "should redirect to the users index page" do
      put 'update', :id => @user
      response.should redirect_to(users_path)
    end

    it "should have a flash message" do
      put 'update', :id => @user
      flash[:notice] =~ /zufällig/i
    end
  end

  describe "authentication" do
    describe "for non-signed-in users" do
      it "should deny access to 'update'" do
        put 'update', :id => @user
        response.should redirect_to(root_path)
      end
    end

    describe "for signed-in users without the admin right" do
      before(:each) do
        @no_admin_role = Role.create valid_attributes_role_azubi.merge(:admin => false)
        @no_admin_role.users << @admin
        test_sign_in(@admin)
      end

      it "should deny access to 'update'" do
        put 'update', :id => @user
        response.should redirect_to(welcome_path)
      end
    end
  end
end
