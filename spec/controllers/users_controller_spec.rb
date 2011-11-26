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

describe UsersController do  
  
  before(:each) do
      @admin = User.create valid_attributes_user
      @role = Role.create valid_attributes_role_admin
      @role.users << @admin
      
      @ausbilder = User.create valid_attributes_user.merge(:email => 'ausbilder@blub.de')
      @role1 = Role.create valid_attributes_role_ausbilder
      @role1.users << @ausbilder
      
      @azubi = User.create valid_attributes_user.merge(:email => 'azubi@blub.de' )
      @role2 = Role.create valid_attributes_role_azubi
      @role2.users << @azubi
      @ausbilder.apprentices << @azubi
  
  end

  describe "method tests for signed in admin" do
    before(:each) do
      test_sign_in(@admin)
    end
    
    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end
      
      it "should find all users" do
        get 'index'
        assigns(:users).should eq(User.all)
      end
    end

    describe "GET 'show'" do
      it "returns http success" do
        get 'show', :id => @admin
        response.should be_success
      end
      
      it "should show the own attributes" do
        get 'show', :id => @admin
        assigns(:user).should eq(@admin)
      end
      
      it "should NOT show other users attributes" do
        get 'show', :id => @ausbilder
        response.should redirect_to(welcome_path)
        get 'show', :id => @azubi
        response.should redirect_to(welcome_path)
      end
    end

    describe "GET 'new'" do
      it "returns http success" do
        get 'new'
        response.should be_success
      end
      
      it "should provide a new user" do
        get 'new'
        assigns(:user).should be_new_record
      end
    end

    describe "GET 'edit'" do
      it "returns http success" do
        get 'edit', :id => @admin
        response.should be_success
      end
      
      it "should find itself" do
        get 'edit', :id => @dmin
        assigns(:user).should eq(@admin)
      end
      
      it "should not find other users" do
        get 'edit', :id =>@azubi
        response.should redirect_to(welcome_path)
      end
    end

    describe "POST 'create'" do
      
      describe "failure" do
        
        it "should not make a new user" do
          expect {
            post 'create', :user => { :email => '' }
                 }.not_to change {User.count}
          expect {
            post 'create', :user => nil
                 }.not_to change {User.count}
        end
        
        it "should render the 'new' page" do
          post 'create', :user => nil
          response.should render_template('users/new')
        end
      end
      
      describe "success" do
        
        it "should make a new user" do
          expect {
            post 'create', :user => valid_attributes_user.merge(:email => 'test@test.de')
                 }.to change {User.count}.by(1)
          
        end
        
        it "should redirect to the user index page" do
          post 'create', :user => valid_attributes_user.merge(:email => 'test@test.de')
          response.should redirect_to(users_path)
        end
        
        it "should have a flash message" do
          post 'create', :user => valid_attributes_user.merge(:email => 'test@test.de')
          flash[:notice].should =~ /erfolgreich/i
        end
      end
    end

    describe "PUT 'update'" do
      it "should find itself" do
        put 'update', :id => @admin
        assigns(:user).should eq(@admin)
      end
      
      describe "failure" do
        it "should not change the user attributes" do
          expect {
            put 'update', :id => @admin, :user => nil
                 }.not_to change { User.find(@admin).updated_at }
        end
        
        it "should render the 'edit' page" do
          put 'update', :id => @admin, :user => nil
          response.should render_template('users/edit')
        end
        
        it "should not change others attributes" do
          expect {
            put 'update', :id => @azubi, :user => @azubi.merge(:email => 'test@test.de')
                 }.not_to change { @azubi.updated_at }       
        end
      end
      
      describe "success" do
        it "should change the user attributes" do
          expect {
          put 'update', :id => @admin, :user => @admin.merge(:email => 'test@test.de')
                 }.to change {Report.find.(@admin).updated_at}
        end
        
        it "should redirect to the user index page" do
          put 'update', :id => @admin, :user => @admin.merge(:email => 'test@test.de')
          response.should redirect_to(users_path)
        end
        
        it "should have a flash message" do
          put 'update', :id => @admin, :user => @admin.merge(:email => 'test@test.de')
          flash[:notice].should =~ /erfolgreich/i
        end
      end
    end

    describe "DELETE 'destroy'" do
      it "should find the right user" do
        delete 'destroy', :id => @azubi
        assigns(:user).should eq(@azubi)
      end
      
      it "should set the delete attribute to TRUE" do
        expect {
        delete 'destroy', :id => @azubi
               }.to change {@azubi.deleted.from(false).to(true)}
      end
      
      it "should NOT destroy the user" do
        
        expect {
          delete 'destroy', :id => @azubi        
               }.not_to change {User.count}
      end
      
      it "should redirect to the user index page" do
        delete 'destroy', :id => @azubi
        response.should redirect_to(users_path)
      end
      
      it "should have a flash message" do
        delete 'destroy', :id => @azubi  
        flash[:notice].should =~ /erfolgreich/i
      end
    end
  end
  
  describe "method tests for signed in instructor" do
    before(:each) do
      test_sign_in(@ausbilder)
    end
    
    describe "GET 'index'" do
      it "should only find all apprentices of the instructor" do
        get 'index'
        assigns(:users).should eq (User.find(@ausbilder).apprentices)
      end
      
    end
    
    describe "GET 'show'" do
      it "should show itself" do
        get 'show', :id => @ausbilder
        assigns(:user).should eq(@ausbilder)
      end
      
      it "should NOT show other users" do
        get 'show', :id => @azubi
        response.should redirect_to(welcome_path)
      end
    end
    
    describe "GET 'edit'" do
      it "should find itself" do
        get 'edit', :id => @ausbilder
        assigns(:user).should eq(@ausbilder)
      end
      
      it "should NOT find other users" do
        get 'edit', :id => @admin
        response.should redirect_to(welcome_path)
        get 'edit', :id => @azubi
        response.should redirect_to(welcome_path)
      end
    end
    
    describe "POST 'create'" do
      describe "failure" do
        it "should NOT make a new user" do
          expect {
            post 'create', :user => nil
                 }.not_to change {User.count}
        end
        
        it "should NOT make a new instructor or admin" do
          expect {
            post 'create', :user => @admin.merge(:email => 'new@email.de')
                 }.not_to change {User.count}
          expect {
            post 'create', :user => @ausbilder.merge(:email => 'new@email.de')
                 }.not_to change {User.count}
        end
        
        it "should redner the 'new' page " do
          post 'create', :user => nil
          response.should render_template('users/new')
        end        
      end
      
      describe "success" do
        it "should make a new apprentice" do
          expect {
            post 'create', :user => @azubi.merge(:email => 'new@email.de')
                 }.to change {User.count}.by(1)
        end
        
        it "should make a new apprentice associated to its instructor" do
          expect {
            post 'create', :user => @azubi.merge(:email => 'new@email.de')
                 }.to change {@ausbilder.apprentices.count}.by(1)
        end
        
        it "should redirect to the users index page" do
          post 'create', :user => @azubi.merge(:email => 'new@email.de')
          response.should redirect_to(users_path)
        end
        
        it "should have a flash message" do
          post 'create', :user => @azubi.merge(:email => 'new@email.de')
          flash[:notice].should =~ /erfolgreich/i
        end
      end
    end
    
    describe "PUT 'update'" do
      describe "failure" do
        it "should not change the users attributes" do
          expect {
            put 'update', :id => @ausbilder, :user => nil
                 }.not_to change {User.find(@ausbilder).updated_at}
        end
        
        it "should render the 'edit' page" do
          put 'update', :id => @ausbilder, :user => nil
          response.should render_template('users/edit')
        end
        
        it "should not change others users attributes" do
          put 'update', :id => @azubi, :user => @azubi.merge(:email => 'new@email.de')
          response.should redirect_to(welcome_path)
        end      
      end
      describe "success" do
        it "should change the own attributes" do
          expect {
            put 'update', :id => @ausbilder, :user => @ausbilder.merge(:email => 'new@email.de')
                 }.to change {User.find(@ausbilder).updated_at}
        end
        
        it "should redirect to the users page" do
          put 'update', :id => @ausbilder, :user => @ausbilder.merge(:email => 'new@email.de')
          response.should redirect_to(users_path)
        end
        
        it "should have a flash message" do
          put 'update', :id => @ausbilder, :user => @ausbilder.merge(:email => 'new@email.de')
          flash[:notice].should =~ /erfolgreich/i
        end
      end    
    end
    describe "DELETE 'destroy'" do
      it "should find the right apprentice" do
        delete 'destroy', :id => @azubi
        assigns(:user).should eq(@azubi)
      end
      
      it "should NOT destroy a user" do
        expect {
          delete 'destroy', :id => @azubi
               }.not_to change {User.count}
      end
      
      it "should set its own attribute deleted to true" do
        expect {
          delete 'destroy', :id => @ausbilder
               }.to change {User.find(@ausbilder).deleted.from(false).to(true)}
      end
      
      it "should set the apprentice's attribute deleted to true" do
        expect {
          delete 'destroy', :id => @azubi
               }.to change {User.find(@azubi).deleted.from(false).to(true)}
      end
      
      it "should NOT destroy a non-associated apprentice" do
        @azubi1 = User.create valid_attributes_user.merge(:email => 'azubi1@test.de')
        @role2 << @azubi1
        delete 'destroy', :id => @azubi1
        response.should redirect_to(welcome_path)
      end 
      
      it "should deny access when destroying an admin or instructor" do
       delete 'destroy', :id => @admin
       response.should redirect_to(welcome_path)
      end
    end    
  end
  describe "method tests for signed in apprentices" do
    before(:each) do
      test_sign_in(@azubi)
    end
    describe "GET 'index'" do
      it "should deny access to index" do
        get 'index'
        response.should redirect_to(welcome_path)
      end
    end
    describe "GET 'show'" do
      it "should find the own attributes" do
        get 'show', :id => @azubi
        assigns(:user).should eq(@azubi)
      end
      it "should deny access to show other users" do
        get 'show', :id => @ausbilder
        response.should redirect_to(welcome_path)
        get 'show', :id => @admin
        response.should redirect_to(welcome_path)
      end
    end
    describe "GET 'edit'" do
      it "should find itself" do
        get 'edit', :id => @azubi
        assigns(:user).should eq(@azubi)
      end
      
      it "should NOT find other users" do
        get 'edit', :id => @admin
        response.should redirect_to(welcome_path)
        get 'edit', :id => @ausbilder
        response.should redirect_to(welcome_path)
      end
    end
    describe "POST 'create'" do
      it "should deny access to create users" do
        post 'create', :user => valid_attributes_user.merge(:email => 'new@azubi.de')
        response.should redirect_to(welcome_path)
      end
    end
    describe "DELETE 'destroy'" do
      it "should set its own attribute deleted to true" do
        expect {
          delete 'destroy', :id => @azubi
               }.to change {User.find(@azubi).deleted.from(false).to(true)}
      end
      
      it "should deny access to delete other users" do
        destroy 'delete', :id => @ausbilder
        response.should redirect_to(welcome_path)
      end
    end
  end
end
