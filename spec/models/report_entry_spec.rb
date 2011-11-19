# encoding: utf-8
require 'spec_helper'

describe ReportEntry do
  before(:each) do
    @user = User.create valid_attributes_user
    @report = @user.reports.create valid_attributes_report
  end

  it "should create a new instance given valid attributes" do
    @report.report_entries.create! valid_attributes
  end

  describe "report associations" do
    before(:each) do
      @entry = @report.report_entries.create valid_attributes
    end

    it "should have a report attribute" do
      @entry.should respond_to(:report)
    end

    it "should have associated the right report" do
      @entry.report_id.should eq(@report.id)
      @entry.report.should eq(@report)
    end
  end

  describe "validations" do
    before(:each) do
      @attr = valid_attributes
    end

    it "should require a report id" do
      ReportEntry.new(@attr).should_not be_valid
    end

    it "should require a starting time" do
      @attr.delete(:date)
      @report.report_entries.build(@attr).should_not be_valid
    end

    it "should require a duration greater than 0" do
      @report.report_entries.build(@attr.merge(:duration_in_hours => 0)).should_not be_valid
      @attr.delete(:duration_in_hours)
      @report.report_entries.build(@attr).should_not be_valid
    end

    it "should require a text" do
      @report.report_entries.build(@attr.merge(:text => "")).should_not be_valid
      @attr.delete(:text)
      @report.report_entries.build(@attr).should_not be_valid
    end
  end
end
