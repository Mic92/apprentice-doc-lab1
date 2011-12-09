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

describe ReportsController do
  before(:each) do
    @user = User.create valid_attributes_user
    @role = Role.create valid_attributes_role_azubi
    @role.users << @user
  end

  describe "GET 'index'" do
    before(:each) do
      @report1 = @user.reports.create valid_attributes_report
      @report1.create_status(:stype => Status.commited)
      @report2 = @user.reports.create valid_attributes_report
      @report2.create_status(:stype => Status.personal)
      @instructor = User.create valid_attributes_user.merge(:email => 'user2@reports.controller')
      @instructor_role = Role.create valid_attributes_role_ausbilder
      @instructor_role.users << @instructor
      @report3 = @instructor.reports.create valid_attributes_report
      @report3.create_status(:stype => Status.commited)
      @instructor.apprentices << @user
      test_sign_in(@user)
    end

    it "returns http success" do
      get 'index'
      response.should be_success
    end

    describe "for users with commit right" do
      it "should only find all reports associated with the user" do
        get 'index'
        assigns(:reports).should eq(@user.reports.order('period_start asc, period_end asc'))
      end
    end

    describe "for users with check right" do
      before(:each) do
        test_sign_in(@instructor)
      end

      it "should only find commited reports associated with assigned apprentices" do
        get 'index'
        assigns(:reports).should eq([ @report1 ])
      end

      it "should find all commited reports with parameter all" do
        get 'index', :all => true
        assigns(:reports).should eq([ @report1, @report3 ])
      end
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @report = @user.reports.create valid_attributes_report
      @entry1 = @report.report_entries.create valid_attributes_entry
      @entry2 = @report.report_entries.create valid_attributes_entry
      test_sign_in(@user)
    end

    it "returns http success" do
      get 'show', :id => @report
      response.should be_success
    end

    it "should find the right report" do
      get 'show', :id => @report
      assigns(:report).should eq(@report)
    end

    it "should find the right entries" do
      get 'show', :id => @report
      assigns(:entries).should eq(@report.report_entries.order('date asc'))
    end
  end

  describe "GET 'new'" do
    before(:each) do
      test_sign_in(@user)
    end
    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "should provide a new report record" do
      get 'new'
      assigns(:report).should be_new_record
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @report = @user.reports.create valid_attributes_report
      test_sign_in(@user)
    end

    it "returns http success" do
      get 'edit', :id => @report
      response.should be_success
    end

    it "should find the right report" do
      get 'edit', :id => @report
      assigns(:report).should eq(@report)
    end
  end

  describe "POST 'create'" do
    before(:each) do
      test_sign_in(@user)
    end
    describe "failure" do
      before(:each) do
        @attr = valid_attributes_report
      end

      it "should not make a new report" do
        expect {
          post 'create', :report => { :period_start => '', :period_end => '' }
        }.not_to change { Report.count }
        expect {
          post 'create', :report => nil
        }.not_to change { Report.count }
      end

      it "should render the 'new' page" do
        post 'create', :report => { :period_start => '', :period_end => '' }
        response.should render_template('reports/new')
        post 'create', :report => nil
        response.should render_template('reports/new')
      end
    end

    describe "success" do
      it "should make a new report" do
        expect {
          post 'create', :report => valid_attributes_report
        }.to change { Report.count }.by(1)
      end

      it "should make a status for the report" do
        expect {
          post 'create', :report => valid_attributes_report
        }.to change { Status.count }.by(1)
      end

      it "should redirect to the reports index page" do
        post 'create', :report => valid_attributes_report
        response.should redirect_to(reports_path)
      end

      it "should have a flash message" do
        post 'create', :report => valid_attributes_report
        flash[:notice].should =~ /erfolgreich/i
      end
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @report = @user.reports.create valid_attributes_report
      @report.create_status valid_attributes_status.merge(:stype => Status.personal)
      @entry = @report.report_entries.create valid_attributes_entry
      test_sign_in(@user)
    end

    it "should find the right report" do
      put 'update', :id => @report
      assigns(:report).should eq(@report)
    end

    describe "failure" do
      it "should not change the report's attributes" do
        expect {
          put 'update', :id => @report, :report => { :period_start => '', :period_end => '' }
        }.not_to change { Report.find(@report).updated_at }
        expect {
          put 'update', :id => @report, :report => nil
        }.not_to change { Report.find(@report).updated_at }
      end

      it "should render the 'edit' page" do
        put 'update', :id => @report, :report => { :period_start => '', :period_end => '' }
        response.should render_template('reports/edit')
        put 'update', :id => @report, :report => nil
        response.should render_template('reports/edit')
      end

      it "should have a flash message if the change conflicts with entries" do
        put 'update', :id => @report, :report => { :period_start => '2011-10-04', :period_end => '2011-10-20' }
        flash[:alert].should =~ /Konflikt/i
      end
    end

    describe "success" do
      before(:each) do
        @attr = valid_attributes_report.merge(:period_start => '2011-09-01')
      end

      it "should change the report's attributes'" do
        expect {
          put 'update', :id => @report, :report => @attr
        }.to change { Report.find(@report).updated_at }
        Report.find(@report).period_start.should eq(@attr.fetch(:period_start).to_date)
      end

      it "should shift the entries dates if the period is shifted" do
        expect {
          put 'update', :id => @report, :report => @attr.merge(:period_start => '2011-11-01',
                                                               :period_end => '2011-12-01')
        }.to change { ReportEntry.find(@entry).date }.by(1.month)
      end

      it "should redirect to the reports index page" do
        put 'update', :id => @report, :report => @attr
        response.should redirect_to(reports_path)
      end

      it "should have a flash message" do
        put 'update', :id => @report, :report => @attr
        flash[:notice].should =~ /erfolgreich/i
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @report = @user.reports.create valid_attributes_report
      test_sign_in(@user)
    end

    it "should find the right report" do
      delete 'destroy', :id => @report
      assigns(:report).should eq(@report)
    end

    it "should destroy the report" do
      expect {
        delete 'destroy', :id => @report
      }.to change { Report.count }.by(-1)
    end

    it "should redirect to the reports index page" do
      delete 'destroy', :id => @report
      response.should redirect_to(reports_path)
    end

    it "should have a flash message" do
      delete 'destroy', :id => @report
      flash[:notice].should =~ /erfolgreich/i
    end
  end

  describe "authentication" do
    before(:each) do
      @report = @user.reports.new valid_attributes_report
      @report.create_status valid_attributes_status
      @report.save
    end

    describe "for non-signed-in users" do
      it "should deny access to 'index'" do
        get 'index'
        response.should redirect_to(root_path)
      end

      it "should deny access to 'show'" do
        get 'show', :id => @report
        response.should redirect_to(root_path)
      end

      it "should deny access to 'new'" do
        get 'new'
        response.should redirect_to(root_path)
      end

      it "should deny access to 'edit'" do
        get 'edit', :id => @report
        response.should redirect_to(root_path)
      end

      it "should deny access to 'create'" do
        post 'create', :report => valid_attributes_report
        response.should redirect_to(root_path)
      end

      it "should deny access to 'update'" do
        put 'update', :id => @report, :report => valid_attributes_report.merge(:period_start => '2011-09-01')
        response.should redirect_to(root_path)
      end

      it "should deny access to 'destroy'" do
        delete 'destroy', :id => @report
        response.should redirect_to(root_path)
      end
    end

    describe "for signed-in users" do
      before(:each) do
        @wrong_user = User.create valid_attributes_user.merge(:email => 'wrong@user.de')
        test_sign_in(@wrong_user)
      end

      it "should require matching users for 'show'" do
        get 'show', :id => @report
        response.should redirect_to(welcome_path)
      end

      it "should allow instructors to view commited reports" do
        @instructor = User.create valid_attributes_user.merge(:email => 'instructor@user.de')
        @check_role = Role.create valid_attributes_role_ausbilder
        @check_role.users << @instructor
        @commited_report = @user.reports.create valid_attributes_report
        @commited_report.create_status valid_attributes_status.merge(:stype => Status.commited)
        test_sign_in(@instructor)
        get 'show', :id => @commited_report
        response.should be_success
      end

      it "should require matching users for 'edit'" do
        get 'edit', :id => @report
        response.should redirect_to(welcome_path)
      end

      it "should require matching users for 'update'" do
        put 'update', :id => @report, :report => valid_attributes_report.merge(:period_start => '2011-09-01')
        response.should redirect_to(welcome_path)
      end

      it "should require matching users for 'destroy'" do
        delete 'destroy', :id => @report
        response.should redirect_to(welcome_path)
      end

      describe "without the read right" do
        before(:each) do
          @no_read_role = Role.create valid_attributes_role.merge(:read => false)
          @no_read_role.users << @user
          test_sign_in(@user)
        end

        it "should deny access to 'index'" do
          get 'index'
          response.should redirect_to(welcome_path)
        end

        it "should deny access to 'show'" do
          get 'show', :id => @report
          response.should redirect_to(welcome_path)
        end
      end

      describe "without the commit right" do
        before(:each) do
          @no_commit_role = Role.create valid_attributes_role.merge(:commit => false)
          @no_commit_role.users << @user
          test_sign_in(@user)
        end

        it "should deny access to 'new'" do
          get 'new'
          response.should redirect_to(welcome_path)
        end

        it "should deny access to 'create'" do
          post 'create', :report => valid_attributes_report
          response.should redirect_to(welcome_path)
        end

        it "should deny access to 'update'" do
          put 'update', :id => @report, :report => valid_attributes_report.merge(:period_start => '2011-09-01')
          response.should redirect_to(welcome_path)
        end

        it "should deny access to 'destroy'" do
          delete 'destroy', :id => @report
          response.should redirect_to(welcome_path)
        end
      end
    end
  end
end
