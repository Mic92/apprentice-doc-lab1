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

describe Report do
  before(:each) do
    @user = User.create valid_attributes_user
  end

  it "should create a new instance given valid attributes" do
    @user.reports.create! valid_attributes_report
  end

  describe "report_entry associations" do
    before(:each) do
      @report = @user.reports.create valid_attributes_report
      @entry1 = ReportEntry.new valid_attributes_entry
      @entry1.report_id = @report.id
      @entry1.save
      @entry2 = ReportEntry.new valid_attributes_entry
      @entry2.report_id = @report.id
      @entry2.save
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
      @attr = valid_attributes_report
    end

    it "should require a beginning date" do
      @attr.delete(:period_start)
      @user.reports.new(@attr).should_not be_valid
    end

    it "should require an ending date" do
      @attr.delete(:period_end)
      @user.reports.new(@attr).should_not be_valid
    end

    it "should require a user id" do
      Report.new(valid_attributes_report).should_not be_valid
    end
  end
end
