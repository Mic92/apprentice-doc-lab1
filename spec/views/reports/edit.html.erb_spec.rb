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

describe "reports/edit.html.erb" do
  before(:each) do
    assign(:report, mock_model(Report,
                               :period_start => '2011-10-01'.to_date,
                               :period_end => '2011-10-31'.to_date))
  end

  it "should state that it's updating a report" do
    render
    rendered.should include('Bericht bearbeiten')
  end

  it "should have a date select for period_start" do
    render
    rendered.should include('id="report_period_start_1i"',
                            'id="report_period_start_2i"',
                            'id="report_period_start_3i"')
  end

  it "should have a date select for period_end" do
    render
    rendered.should include('id="report_period_end_1i"',
                            'id="report_period_end_2i"',
                            'id="report_period_end_3i"')
  end

  it "should have a submit button" do
    render
    rendered.should include('type="submit"')
  end

  it "should have a link to the reports index page" do
    render
    rendered.should include("href=\"#{reports_path}\"")
  end
end
