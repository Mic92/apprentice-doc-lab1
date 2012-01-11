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

describe ReportEntry do
  before(:each) do
    @user = User.create valid_attributes_user
    @report = @user.reports.create valid_attributes_report
  end

  it "should create a new instance given valid attributes" do
    @report.report_entries.create! valid_attributes_entry
  end

  describe "report associations" do
    before(:each) do
      @entry = @report.report_entries.create valid_attributes_entry
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
      @attr = valid_attributes_entry
    end

    it "should require a report id" do
      ReportEntry.new(@attr).should_not be_valid
    end

    it "should require a starting time" do
      @attr.delete(:date)
      @report.report_entries.build(@attr).should_not be_valid
    end

#    it "should require a duration greater than 0" do
#      @report.report_entries.build(@attr.merge(:duration_in_hours => 0)).should_not be_valid
#      @attr.delete(:duration_in_hours)
#      @report.report_entries.build(@attr).should_not be_valid
#    end

    it "should require a text" do
      @report.report_entries.build(@attr.merge(:text => "")).should_not be_valid
      @attr.delete(:text)
      @report.report_entries.build(@attr).should_not be_valid
    end
  end
end
