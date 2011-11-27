# encoding: utf-8
#
# Copyright (C) 2011, Max Löwen <Max.Loewen@mailbox.tu-dresden.de>
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

describe ReviewsController do
  before(:each) do
    @apprentice = User.create valid_attributes_user
    @role_a = Role.create valid_attributes_role_azubi
    @role_a.users << @apprentice
    @instructor = User.create valid_attributes_user
    @role_i = Role.create valid_attributes_role_ausbilder
    @role_i.users << @instructor
    @instructor.apprentices << @apprentice
    @report1 = @apprentice.reports.create valid_attributes_report
    @report2 = @apprentice.reports.create valid_attributes_report
    @report3 = @apprentice.reports.create valid_attributes_report
    @report4 = @apprentice.reports.create valid_attributes_report
    @report_i = @instructor.reports.create valid_attributes_report
    @status1 = @report1.create_status valid_attributes_status.merge(:stype => Status.personal)
    @status2 = @report2.create_status valid_attributes_status.merge(:stype => Status.commited)
    @status3 = @report3.create_status valid_attributes_status.merge(:stype => Status.rejected)
    @status4 = @report4.create_status valid_attributes_status.merge(:stype => Status.accepted)
  end

  describe "GET 'create'" do
    it "returns http success" do
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'update'" do
    it "returns http success" do
      get 'update'
      response.should be_success
    end
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      get 'destroy'
      response.should be_success
    end
  end

end
