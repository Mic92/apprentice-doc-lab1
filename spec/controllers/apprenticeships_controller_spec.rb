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

describe ApprenticeshipsController do
  before(:each) do
    @instructor = User.create valid_attributes_user
    @instructor_role = Role.create valid_attributes_role_ausbilder
    @instructor_role.users << @instructor
  end

  describe "POST 'create'" do
    describe "failure" do
      before(:each) do
        test_sign_in(@instructor)
      end

      it "should not change the instructor's apprentices" do
        expect {
          post 'create', :apprentice_id => 20
        }.not_to change { User.find(@instructor).apprentices.count }
      end

      it "should redirect to the user index page" do
        post 'create', :apprentice_id => 20
        response.should redirect_to(users_path)
      end

      it "should have a flash message" do
        post 'create', :apprentice_id => 20
        flash[:notice].should =~ /nicht/i
      end
    end

    describe "success" do
      before(:each) do
        @apprentice = User.create valid_attributes_user.merge(:email => 'azubi@business.de')
        @apprentice_role = Role.create valid_attributes_role_azubi
        @apprentice_role.users << @apprentice
        test_sign_in(@instructor)
      end

      it "should find the right apprentice" do
        post 'create', :apprentice_id => @apprentice
        assigns(:apprentice).should eq(@apprentice)
      end

      it "should assign the apprentice to the instructor" do
        expect {
          post 'create', :apprentice_id => @apprentice
        }.to change { User.find(@instructor).apprentices.count }.by(1)
        @instructor.apprentices.should eq([ @apprentice ])
      end

      it "should only assign users without admin right" do
        @admin_role = Role.create valid_attributes_role_admin
        @admin_role.users << @apprentice
        expect {
          post 'create', :apprentice_id => @apprentice
        }.not_to change { User.find(@instructor).apprentices.count }
      end

      it "should only assign users without check right" do
        @instructor_role.users << @apprentice
        expect {
          post 'create', :apprentice_id => @apprentice
        }.not_to change { User.find(@instructor).apprentices.count }
      end

      it "should redirect to the users index page" do
        post 'create', :apprentice_id => @apprentice
        response.should redirect_to(users_path)
      end

      it "should have a flash message" do
        post 'create', :apprentice_id => @apprentice
        flash[:notice].should =~ /wurde/i
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @apprentice = User.create valid_attributes_user.merge(:email => 'azubi@business.de')
      @apprentice_role = Role.create valid_attributes_role_azubi
      @apprentice_role.users << @apprentice
      @instructor.apprentices << @apprentice
      test_sign_in(@instructor)
    end

    describe "failure" do
      it "should not change the instructor's apprentices" do
        expect {
          delete 'destroy', :id => 20
        }.not_to change { User.find(@instructor).apprentices.count }
      end

      it "should redirect to the users index page" do
        delete 'destroy', :id => 20
        response.should redirect_to(users_path)
      end

      it "should have a flash message" do
        delete 'destroy', :id => 20
        flash[:notice].should =~ /nicht/i
      end
    end

    describe "success" do
      it "should find the right apprentice" do
        delete 'destroy', :id => @apprentice
        assigns(:apprentice).should eq(@apprentice)
      end

      it "should remove the assignment" do
        expect {
          delete 'destroy', :id => @apprentice
        }.to change { User.find(@instructor).apprentices.count }.by(-1)
        @instructor.apprentices.should_not include(@apprentice)
      end

      it "should redirect to the users index page" do
        delete 'destroy', :id => @apprentice
        response.should redirect_to(users_path)
      end

      it "should have a flash message" do
        delete 'destroy', :id => @apprentice
        flash[:notice].should =~ /wurde/i
      end
    end
  end

  describe "authentication" do
    before(:each) do
      @apprentice = User.create valid_attributes_user.merge(:email => 'azubi@business.de')
      @apprentice_role = Role.create valid_attributes_role_azubi
      @apprentice_role.users << @apprentice
    end

    describe "for non-signed-in users" do
      it "should deny access to 'create'" do
        post 'create', :apprentice_id => @apprentice
        response.should redirect_to(root_path)
      end

      it "should deny access to 'destroy'" do
        delete 'destroy', :id => @apprentice
        response.should redirect_to(root_path)
      end
    end

    describe "for signed-in users without the check right" do
      before(:each) do
        @no_check_role = Role.create valid_attributes_role.merge(:check => false)
        @no_check_role.users << @instructor
        test_sign_in(@instructor)
      end

      it "should deny access to 'create'" do
        post 'create', :apprentice_id => @apprentice
        response.should redirect_to(welcome_path)
      end

      it "should deny access to 'destroy'" do
        delete 'destroy', :id => @apprentice
        response.should redirect_to(welcome_path)
      end
    end
  end
end
