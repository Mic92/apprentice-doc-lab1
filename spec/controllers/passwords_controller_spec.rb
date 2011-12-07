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
    @user = User.create valid_attributes_user.merge(:email => 'azubi@business.de')
    @role = Role.create valid_attributes_role
    @role.users << @user
    @user.pw_expired_at = Time.now + 600
    @user.save
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_succes
    end
  end

  describe "POST 'create'" do
    it "should find the right user" do
      post 'create', :email => @user.email
      assigns(:user).should eq(@user)
    end

    it "should generate a password with lenght 8" do
      post 'show', :email => @user.email, :id => @user.pw_recovery_hash
      assigns(:password).class.should eq(String)
      assigns(:password).length.should eq(8)
    end

    it "should change the user's password" do
      expect {
        post 'show', :email => @user.email, :id => @user.pw_recovery_hash
      }.to change { User.find(@user).hashed_password }
    end

    it "should redirect to the users index page" do
      post 'show', :email => @user.email, :id => @user.pw_recovery_hash
      response.should redirect_to(root_path)
    end

    it "should have a flash message" do
      post 'show', :email => @user.email, :id => @user.pw_recovery_hash
      flash[:notice] =~ /zufällig/i
    end
  end
end
