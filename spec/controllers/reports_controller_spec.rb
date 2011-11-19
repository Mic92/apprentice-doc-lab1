# encoding: utf-8
require 'spec_helper'

describe ReportsController do
  describe "GET 'index'" do
    before(:each) do
      @user = User.create valid_attributes_user
      @report1 = @user.reports.create valid_attributes_report
      @report2 = @user.reports.create valid_attributes_report
    end

    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "should find all reports" do
      get 'index'
      assigns(:reports).should eq(Report.all)
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @user = User.create valid_attributes_user
      @report = @user.reports.create valid_attributes_report
      @entry1 = @report.report_entries.create valid_attributes_entry
      @entry2 = @report.report_entries.create valid_attributes_entry
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
      assigns(:entries).should eq(@report.report_entries)
    end
  end

  describe "GET 'new'" do
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
      @user = User.create valid_attributes_user
      @report = @user.reports.create valid_attributes_report
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
        response.should render_template('report/new')
        post 'create', :report => nil
        response.should render_template('report/new')
      end
    end

    describe "success" do
      it "should make a new report" do
        expect {
          post 'create', :report => valid_attributes_report
        }.to change { Report.count }.by(1)
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
      @user = User.create valid_attributes_user
      @report = @user.reports.create valid_attributes_report
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
      @user = User.create valid_attributes_user
      @report = @user.reports.create valid_attributes_report
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
      @user = User.create valid_attributes_user
      @report = @user.reports.create valid_attributes_report
    end

    describe "for non-signed-in users" do
      it "should deny access to 'index'" do
        get 'index'
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'show'" do
        get 'show', :id => @report
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'new'" do
        get 'new'
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'edit'" do
        get 'edit', :id => @report
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'create'" do
        post 'create', :report => valid_attributes_report
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        put 'update', :id => @report, :report => valid_attributes_report
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'destroy'" do
        delete 'destroy', :id => @report
        response.should redirect_to(signin_path)
      end
    end
  end
end
