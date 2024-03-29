# encoding: utf-8
#
# Copyright (C) 2011, Marcus Hänsch <haensch.marcus@gmail.com>
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

describe RolesController do

  describe "method tests for signed in admin" do
    #creating signed in user with admin right

    before(:each) do
    @user = User.create valid_attributes_user
    @role_admin = Role.create valid_attributes_role.merge(:admin => true, :level => 1, :name => 'Admin')
    @role_admin.users << @user
    test_sign_in(@user)

    end

    #single method testing
    
    describe "GET 'index'" do
      before(:each) do
      @role = Role.create valid_attributes_role
      end
      
      it "returns http success" do
        get 'index'
        response.should be_success
      end
      
      it "should find all roles" do
        get 'index'
        assigns(:roles).should eq(Role.all)
      end
    end
    describe "GET 'new'" do

      it "returns http success" do
        get 'new'
        response.should be_success
      end

      it "should provide a new role record" do
        get 'new'
        assigns(:role).should be_new_record
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
        assigns(:role).should eq(@role)
      end
    end

    describe "POST 'create'" do


      describe "success" do

        it "should make a new role" do
          expect {
            post 'create', :role => valid_attributes_role
                 }.to change {Role.count }.by(1)
        end

        it "should redirect to the welcome page" do
            post 'create', :role => valid_attributes_role
            response.should redirect_to(roles_path)
        end

        it "should have a flash message" do
          post 'create', :role => valid_attributes_role
          flash[:notice].should =~ /erfolgreich/i
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
          response.should render_template('roles/new')
        end
      end
    end

    describe "PUT 'update'" do
      before(:each) do
      @role = Role.create valid_attributes_role
      end

      it "should find the right role" do
        put 'update', :id => @role
        assigns(:role).should eq(@role)
      end

      describe "failure" do
        it "should not change the role attributes" do
          expect {
            put 'update', :id => @role, :role => nil
                 }.not_to change {Role.find(@role).updated_at }
        end

        it "should render the 'edit' page" do
          put 'update', :id => @role, :role => nil
          response.should render_template('roles/edit')
        end
      end

      describe "success" do
        before(:each) do
          @attributes = valid_attributes_role.merge(:export => false)
        end

        it "should change the role attributes" do
          expect {
            put 'update', :id => @role, :role => @attributes
                 }.to change {Role.find(@role).updated_at }
          Role.find(@role).export.should eq(@attributes.fetch(:export))
        end

        it "should redirect to the welcome page" do
          put 'update', :id => @role, :role => @attributes
          response.should redirect_to(roles_path)
        end

        it "should have a flash message" do
          put 'update', :id => @role, :role => @attributes
          flash[:notice].should =~ /erfolgreich/i
        end
      end
    end

    describe "delete 'destroy'" do
      before(:each) do
        @role = Role.create valid_attributes_role
      end

      it "should find the right role" do
        delete 'destroy', :id => @role
        assigns(:role).should eq(@role)
      end

      it "should not destroy a role with associated users" do
        @role.users.create valid_attributes_user.merge(:email => 'rofl@copter.de')
        expect {
          delete 'destroy', :id => @role
               }.not_to change { Role.count }
      end
      it "should destroy the role" do
        expect {
          delete 'destroy', :id => @role
               }.to change {Role.count}.by(-1)
      end

      it "should redirect to the welcome page" do
        delete 'destroy', :id => @role
        response.should redirect_to(roles_path)
      end

      it "should have a flash message" do
        delete 'destroy', :id => @role
        flash[:notice].should =~ /erfolgreich/i
      end
    end
  end

  #testing the authentication for sign-in and admin right

  describe "authentication" do
    before(:each) do
      @role = Role.create valid_attributes_role.merge(:level => 3, :name => 'no admin')
    end

    describe "testing non-signed-in users" do
      
      it "should deny access to 'index'" do
        get 'index'
        response.should redirect_to(root_path)
      end
      
      it "should deny access to 'new'" do
        get 'new'
        response.should redirect_to(root_path)
      end

      it "should deny access to 'edit'" do
        get 'edit', :id => @role
        response.should redirect_to(root_path)
      end

      it "should deny access to 'create'" do
        post 'create', :role => valid_attributes_role
        response.should redirect_to(root_path)
      end

      it "should deny access to 'update'" do
        put 'update', :id => @role, :role => valid_attributes_role
        response.should redirect_to(root_path)
      end

      it "should deny access to 'destroy'" do
        delete 'destroy', :id => @role
        response.should redirect_to(root_path)
      end
    end

    describe "testing signed-in users without admin right" do
      before(:each) do
        @user = User.create valid_attributes_user
        @role_no_admin = Role.create valid_attributes_role.merge(:admin => false, :level => 4, :name => 'no admin')
        @role_no_admin.users << @user
        test_sign_in(@user)
      end
      
      it "should deny access to 'index'" do
        get 'index'
        response.should redirect_to(welcome_path)
      end

      it "should deny access to 'new'" do
        get 'new'
        response.should redirect_to(welcome_path)
      end

      it "should deny access to 'edit'" do
        get 'edit', :id => @role
        response.should redirect_to(welcome_path)
      end

      it "should deny access to 'create'" do
        post 'create', :role => valid_attributes_role
        response.should redirect_to(welcome_path)
      end

      it "should deny access to 'update'" do
        put 'update', :id => @role, :role => valid_attributes_role
        response.should redirect_to(welcome_path)
      end

      it "should deny access to 'destroy'" do
        delete 'destroy', :id => @role
        response.should redirect_to(welcome_path)
      end
    end
  end

end
