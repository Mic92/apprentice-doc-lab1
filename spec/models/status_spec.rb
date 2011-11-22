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

describe Status do

  it "should create a new instance with valid attributes" do
    Status.create! valid_attributes_status
  end

  describe "report associations" do
    before(:each) do
      @report = Report.create valid_attributes_report
      @stauts = @report.status
    end
    
    it "should have an report attribute" do
      @status.should respond_to(:report)
    end
    
    it "should have the right associated reports" do
      @report.status.should eq(@status)
    
    end
    
    it "should not destroy its reports when destroyed itself" do
      @report_count = Report.all.length
      @status.destroy
      @report_count.should eq(Report.all.length)
      
    end

   end

   describe "validations" do
   
    before(:each) do
        @attributes = valid_attributes_status
    end

    it "should require attribute stype" do
      @attributes.delete(:level)
      Status.new(@attributes).should_not be_valid
    end
    
    it "should require attribute report" do
      @attributes.delete(:report)
      Status.new(@attributes).should_not be_valid
    end

    it "should require attribute date" do
      @attributes.delete(:date)
      Status.new(@attributes).should_not be_valid
    end

  end

end
