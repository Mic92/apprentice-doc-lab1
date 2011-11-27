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
    @report = mock_model(Report, :period_start => '2011-10-01'.to_date, :period_end => '2011-10-31'.to_date)
    @entry1 = mock_model(ReportEntry, :date => '2011-10-02 08:00:00'.to_datetime, :duration_in_hours => 1.5, :text => 'Entry created.')
    @entry2 = mock_model(ReportEntry, :date => '2011-10-02 10:00:00'.to_datetime, :duration_in_hours => 0.1, :text => 'View tested.')
    assign(:entries, [ @entry1, @entry2 ])
    assign(:report, @report)
  end

  it "should display the beginning date of the report" do
    render
    rendered.should include(@report.period_start.to_s)
  end

  it "should display the ending date of the report" do
    render
    rendered.should include(@report.period_end.to_s)
  end

  it "should display the dates/times" do
    render
    rendered.should include(@entry1.date.to_formatted_s(:short), @entry2.date.to_formatted_s(:short))
  end

  it "should display the duration" do
    render
    rendered.should include(@entry1.duration_in_hours.to_i.to_s, (@entry1.duration_in_hours.hours / 1.minute % 60).to_i.to_s)
  end

  it "should display the text" do
    render
    rendered.should include(@entry1.text, @entry2.text)
  end

  it "should have links to delete entries" do
    render
    rendered.should include("href=\"/reports/#{@report.id}/report_entries/#{@entry1.id}\"", "href=\"/reports/#{@report.id}/report_entries/#{@entry2.id}\"")
  end

  it "should have a link to create a new entry" do
    render
    rendered.should include("href=\"#{new_report_report_entry_path(@report)}\"")
  end
end
