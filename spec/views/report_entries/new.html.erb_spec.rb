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

describe "report_entries/new.html.erb" do
  before(:each) do
    @report = assign(:report, mock_model(Report, valid_attributes_report.merge(:id => 1)))
    assign(:entry, mock_model(ReportEntry,
                              :date => nil,
                              :duration_in_hours => nil,
                              :text => nil,
                              :id => 2
                             ).as_new_record)
    params[:report_id] = @report.id
  end

  it "should state that it's creating an entry" do
    render
    rendered.should include('Eintrag anlegen')
  end

  it "should have a date/time select for date" do
    render
    rendered.should include('id="report_entry_date_1i"',
                            'id="report_entry_date_2i"',
                            'id="report_entry_date_3i"',
                            'id="report_entry_date_4i"',
                            'id="report_entry_date_5i"')
  end

  it "should have input fields for duration_in_hours" do
    render
    rendered.should include('id="duration_hours"', 'id="duration_minutes"')
  end

  it "should have a text field for text" do
    render
    rendered.should include('id="report_entry_text"')
  end

  it "should have a link to the report show page" do
    render
    rendered.should include("href=\"#{report_path(@report)}\"")
  end
end
