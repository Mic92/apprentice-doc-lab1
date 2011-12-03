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

describe "reports/show.html.erb" do
  before(:each) do
    @commit_role = mock_model(Role, :commit? => true, :check? => false)
    @check_role = mock_model(Role, :commit? => false, :check? => true)
    @apprentice = mock_model(User, :role  => @commit_role)
    @instructor = mock_model(User, :role => @check_role)
    @personal_status = mock_model(Status, :stype => Status.personal, :comment => nil, :comment? => false)
    @commited_status = mock_model(Status, :stype => Status.commited, :comment => nil, :comment? => false)
    @rejected_status = mock_model(Status, :stype => Status.rejected, :comment => 'Nicht gut genug.', :comment? => true)
    @personal_report = mock_model(Report, :period_start => '2011-10-01'.to_date,
                                  :period_end => '2011-10-31'.to_date,
                                  :status => @personal_status)
    @commited_report = mock_model(Report, :period_start => '2011-10-01'.to_date,
                                  :period_end => '2011-10-31'.to_date,
                                  :status => @commited_status)
    @rejected_report = mock_model(Report, :period_start => '2011-10-01'.to_date,
                                  :period_end => '2011-10-31'.to_date,
                                  :status => @rejected_status)
    @entry1 = mock_model(ReportEntry, :date => '2011-10-02 08:00:00'.to_datetime, :duration_in_hours => 1.5, :text => 'Entry created.')
    @entry2 = mock_model(ReportEntry, :date => '2011-10-02 10:00:00'.to_datetime, :duration_in_hours => 0.1, :text => 'View tested.')
    assign(:entries, [ @entry1, @entry2 ])
    assign(:report, @personal_report)
    assign(:current_user, @apprentice)
  end

  it "should display the beginning date of the report" do
    render
    rendered.should include(l @personal_report.period_start)
  end

  it "should display the ending date of the report" do
    render
    rendered.should include(l @personal_report.period_end)
  end

  it "should display the comment" do
    assign(:report, @rejected_report)
    render
    rendered.should include(@rejected_report.status.comment)
  end

  it "should display the dates/times" do
    render
    rendered.should include((l @entry1.date, :format => :short), (l @entry2.date, :format => :short))
  end

  it "should display the duration" do
    render
    rendered.should include(@entry1.duration_in_hours.to_i.to_s, (@entry1.duration_in_hours.hours / 1.minute % 60).to_i.to_s)
  end

  it "should display the text" do
    render
    rendered.should include(@entry1.text, @entry2.text)
  end

  describe "for users with commit right" do
    it "should have links to delete entries" do
      render
      rendered.should include("href=\"/reports/#{@personal_report.id}/report_entries/#{@entry1.id}\"",
                              "href=\"/reports/#{@personal_report.id}/report_entries/#{@entry2.id}\"")
    end

    it "should have a link to create a new entry" do
      render
      rendered.should include("href=\"#{new_report_report_entry_path(@personal_report)}\"")
    end

    it "should have a link to commit the report" do
      render
      rendered.should include("href=\"#{reviews_path}?report_id=#{@personal_report.id}\"")
    end

    it "should have a link to cancle the review" do
      assign(:report, @commited_report)
      render
      rendered.should include("href=\"#{review_path(@commited_report)}\"", "data-method=\"delete\"")
    end
  end

  describe "for users with check right" do
    before(:each) do
      assign(:report, @commited_report)
      assign(:current_user, @instructor)
    end

    it "should have a link to accept the report" do
      render
      rendered.should include("href=\"#{review_path(@commited_report)}\"", "data-method=\"delete\"")
    end

    it "should have a link to reject the report" do
      render
      rendered.should include("href=\"#{edit_review_path(@commited_report)}\"")
    end
  end
end
