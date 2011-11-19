# encoding: utf-8
require 'spec_helper'

describe ReportEntriesController do
  before(:each) do
    @user = User.create valid_attributes_user
    @report = @user.reports.create valid_attributes_report
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new', :report_id => @report
      response.should be_success
    end

    it "should provide a new entry record" do
      get 'new', :report_id => @report
      assigns(:entry).should be_new_record
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @entry = @report.report_entries.create valid_attributes_entry
    end

    it "returns http success" do
      get 'edit', :report_id => @report, :id => @entry
      response.should be_success
    end

    it "should find the right entry" do
      get 'edit', :report_id => @report, :id => @entry
      assigns(:entry).should eq(@entry)
    end
  end

  describe "POST 'create'" do
    it "should find the right report" do
      post 'create', :report_id => @report
      assigns(:report).should eq(@report)
    end

    describe "failure" do
      before(:each) do
        @attr = valid_attributes_entry
      end

      it "should not make a new entry" do
        expect {
          post 'create', :report_id => @report, :report_entry => { :date => '', :duration_in_hours => '', :text => '' }
        }.not_to change { ReportEntry.count }
        expect {
          post 'create', :report_id => @report, :report_entry => nil
        }.not_to change { ReportEntry.count }
      end

      it "should render the 'new' page" do
        post 'create', :report_id => @report, :report_entry => { :date => '', :duration_in_hours => '', :text => '' }
        response.should render_template('report_entries/new')
        post 'create', :report_id => @report, :report_entry => nil
        response.should render_template('report_entries/new')
      end
    end

    describe "success" do
      it "should make a new entry" do
        expect {
          post 'create', :report_id => @report, :report_entry => valid_attributes_entry
        }.to change { ReportEntry.count }.by(1)
      end

      it "should redirect to the report show page" do
        post 'create', :report_id => @report, :report_entry => valid_attributes_entry
        response.should redirect_to(@report)
      end

      it "should have a flash message" do
        post 'create', :report_id => @report, :report_entry => valid_attributes_entry
        flash[:notice].should =~ /erfolgreich/i
      end
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @entry = @report.report_entries.create valid_attributes_entry
    end

    it "should find the right entry" do
      put 'update', :report_id => @report, :id => @entry
      assigns(:entry).should eq(@entry)
    end

    describe "failure" do
      it "should not change the entry's attributes" do
        expect {
          put 'update', :report_id => @report, :id => @entry, :report_entry => { :date => '', :duration_in_hours => '', :text => '' }
        }.not_to change { ReportEntry.find(@entry).updated_at }
        expect {
          put 'update', :report_id => @report, :id => @entry, :report_entry => nil
        }.not_to change { ReportEntry.find(@entry).updated_at }
      end

      it "should render the 'edit' page" do
        put 'update', :report_id => @report, :id => @entry, :report_entry => { :date => '', :duration_in_hours => '', :text => '' }
        response.should render_template('report_entries/edit')
        put 'update', :report_id => @report, :id => @entry, :report_entry => nil
        response.should render_template('report_entries/edit')
      end
    end

    describe "success" do
      before(:each) do
        @attr = valid_attributes_entry.merge(:text => 'Entry edited.')
      end

      it "should change the entry's attributes" do
        expect {
          put 'update', :report_id => @report, :id => @entry, :report_entry => @attr
        }.to change { ReportEntry.find(@entry).updated_at }
        ReportEntry.find(@entry).text.should eq(@attr.fetch(:text))
      end

      it "should redirect to the report show page" do
        put 'update', :report_id => @report, :id => @entry, :report_entry => @attr
        response.should redirect_to(@report)
      end

      it "should have a flash message" do
        put 'update', :report_id => @report, :id => @entry, :report_entry => @attr
        flash[:notice].should =~ /erfolgreich/i
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @entry = @report.report_entries.create valid_attributes_entry
    end

    it "should find the right entry" do
      delete 'destroy', :report_id => @report, :id => @entry
      assigns(:entry).should eq(@entry)
    end

    it "should destroy the entry" do
      expect {
        delete 'destroy', :report_id => @report, :id => @entry
      }.to change { ReportEntry.count }.by(-1)
    end

    it "should redirect to the report show page" do
      delete 'destroy', :report_id => @report, :id => @entry
      response.should redirect_to(@report)
    end

    it "should have a flash message" do
      delete 'destroy', :report_id => @report, :id => @entry
      flash[:notice].should =~ /erfolgreich/i
    end
  end

  describe "authentication" do
    before(:each) do
      @entry = @report.report_entries.create valid_attributes_entry
    end

    describe "for non-signed-in users" do
      it "should deny access to 'new'" do
        get 'new', :report_id => @report
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'edit'" do
        get 'edit', :report_id => @report, :id => @entry
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'create'" do
        post 'create', :report_id => @report, :report_entry => valid_attributes_entry
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        put 'update', :report_id => @report, :id => @entry, :report_entry => valid_attributes_entry
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'destroy'" do
        delete 'destroy', :report_id => @report, :id => @entry
        response.should redirect_to(signin_path)
      end
    end
  end
end
