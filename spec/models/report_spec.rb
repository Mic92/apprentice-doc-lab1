# encoding: utf-8
require 'spec_helper'

describe Report do
  def valid_attributes
    {
      :period_start => '2011-10-01',
      :period_end => '2011-10-31',
    }
  end

  def valid_attributes_user
    {
      :name => 'Mustermann',
      :forename => 'Max',
      :zipcode => '01234',
      :street => 'Musterstraße',
      :city => 'Musterstadt',
      :email => 'max@mustermann.de',
      :deleted => false
    }
  end

  def valid_attributes_entry
    {
      :date => '2011-10-02 08:00:00',
      :duration_in_hours => 1.5,
      :text => 'Entry created.'
    }
  end

  before(:each) do
    @user = User.create valid_attributes_user
  end

  it "should create a new instance given valid attributes" do
    @user.reports.create! valid_attributes
  end

  describe "report_entry associations" do
    before(:each) do
      @report = @user.reports.create valid_attributes
      @entry1 = @report.report_entries.create valid_attributes_entry
      @entry2 = @report.report_entries.create valid_attributes_entry
    end

    it "should have a report_entries attribute" do
      @report.should respond_to(:report_entries)
    end

    it "should have the right associated report_entries" do
      @report.report_entries.should eq([ @entry1, @entry2 ])
    end

    it "should destroy associated report_entries" do
      @report.destroy
      [ @entry1, @entry2 ].each do |entry|
        ReportEntry.find_by_id(entry.id).should be_nil
      end
    end
  end

  describe "validations" do
    before(:each) do
      @attr = valid_attributes
    end

    it "should require a beginning date" do
      @attr.delete(:period_start)
      Report.new(@attr).should_not be_valid
    end

    it "should require an ending date" do
      @attr.delete(:period_end)
      Report.new(@attr).should_not be_valid
    end

    it "should require a user id" do
      Report.new(valid_attributes).should_not be_valid
    end
  end
end
