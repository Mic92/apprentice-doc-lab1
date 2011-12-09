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

describe ReportBotController do
  before(:each) do
    @apprentice = User.create valid_attributes_user.merge(:email => 'apprentis@mustermann.de')
    @role_a = Role.create valid_attributes_role_azubi
    @role_a.users << @apprentice
    @instructor = User.create valid_attributes_user.merge(:email => 'instructor@mustermann.de')
    @role_i = Role.create valid_attributes_role_ausbilder
    @role_i.users << @instructor
    @instructor.apprentices << @apprentice
    @report_p = @apprentice.reports.create valid_attributes_report
    @report_c = @apprentice.reports.create valid_attributes_report
    @report_r = @apprentice.reports.create valid_attributes_report
    @report_a = @apprentice.reports.create valid_attributes_report
    @status_p = @report_p.create_status valid_attributes_status.merge(:stype => Status.personal)
    @status_c = @report_c.create_status valid_attributes_status.merge(:stype => Status.commited)
    @status_r = @report_r.create_status valid_attributes_status.merge(:stype => Status.rejected)
    @status_a = @report_a.create_status valid_attributes_status.merge(:stype => Status.accepted)
    @report_older_than_period = @apprentice.reports.create valid_attributes_report
    @status_older_than_period = @report_older_than_period.create_status valid_attributes_status.merge(:stype => Status.commited)
    @status_older_than_period.update_attributes :updated_at => (Time.now - ReportBotController.instructor_period - 1.minutes)
  end

  describe "method tests for unwritten" do

  end

  describe "method tests for unchecked" do
    it "should send an e-mail" do
      get 'unchecked'
      ActionMailer::Base.deliveries.last.to.should == [@instructor.email]
    end
  end

  describe "mailer-tests" do
    it "should send an unchecked_reports-email" do
      @data = { :instructor => @instructor, :unchecked_reports_num => 1 }
      UserMailer.unchecked_reports_mail(@data).deliver
      ActionMailer::Base.deliveries.last.to.should == [@instructor.email]
    end
  end
end
