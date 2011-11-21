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

describe "reports/index.html.erb" do
  before(:each) do
    @report1 = mock_model(Report, :period_start => '2011-10-01', :period_end => '2011-10-31')
    @report2 = mock_model(Report, :period_start => '2011-11-01', :period_end => '2011-11-30')
    assign(:reports, [ @report1, @report2 ])
  end

  it "should display the beginning dates" do
    render
    rendered.should include(@report1.period_start.to_s, @report2.period_start.to_s)
  end

  it "should display the ending dates" do
    render
    rendered.should include(@report1.period_end.to_s, @report2.period_end.to_s)
  end
end
