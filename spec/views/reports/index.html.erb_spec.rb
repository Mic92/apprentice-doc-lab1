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
    @commit_role = mock_model(Role, :read? => true, :commit? => true, :check? => false, :export? => false)
    @check_role = mock_model(Role, :read? => true, :commit? => false, :check? => true, :export? => false)
    @export_role = mock_model(Role, :read? => false, :commit? => false, :check? => false, :export? => true)
    @apprentice = mock_model(User, :name => 'Azubi',
                             :forename => 'One',
                             :role  => @commit_role)
    @instructor = mock_model(User, :name => 'Ausbilder',
                             :forename => 'One',
                             :role  => @check_role)
    @exporter = mock_model(User, :name => 'Exporter',
                           :forename => 'One',
                           :role => @export_role)
    @personal_status = mock_model(Status, :stype => Status.personal)
    @rejected_status = mock_model(Status, :stype => Status.rejected)
    @report1 = mock_model(Report, :period_start => '2011-10-01'.to_date,
                          :period_end => '2011-10-31'.to_date,
                          :user => @apprentice,
                          :status => @personal_status)
    @report2 = mock_model(Report, :period_start => '2011-11-01'.to_date,
                          :period_end => '2011-11-30'.to_date,
                          :user => @apprentice,
                          :status => @rejected_status)
    assign(:reports, [ @report1, @report2 ])
    assign(:current_user, @apprentice)
  end

  it "should display the beginning dates" do
    render
    rendered.should include((l @report1.period_start),(l @report2.period_start))
  end

  it "should display the ending dates" do
    render
    rendered.should include((l @report1.period_end),(l @report2.period_end))
  end

  it "should display the statuses" do
    render
    rendered.should include('nicht vorgelegt', 'abgelehnt')
  end

  describe "for users with commit right" do
    it "should have a link to create a new report" do
      render
      rendered.should include('href="/reports/new"')
    end

    it "should have links to delete the reports" do
      render
      rendered.should include("href=\"/reports/#{@report1.id}\"", "href=\"/reports/#{@report2.id}\"")
    end
  end

  describe "for users with check right" do
    before(:each) do
      assign(:current_user, @instructor)
    end

    it "should display the apprentices names" do
      render
      rendered.should include(@apprentice.forename, @apprentice.name)
    end
  end

  describe "for users with export right" do
    before(:each) do
      assign(:current_user, @exporter)
    end

    it "should have links to export the reports" do
      render
      rendered.should include("href=\"/print_reports/#{@report1.id}\"", "href=\"/print_reports/#{@report2.id}\"")
    end
  end
end
