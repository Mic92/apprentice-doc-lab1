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

class ReportBotController < ApplicationController
  def instructor_period
    2.weeks
  end

  def apprentice_period
    1.months
  end

  def unwritten
    @apprentices = User.joins(:role).where( :roles => {:commit => true} )
    @apprentices.each do |apprentice|
      #TODO überprüfen, ob an jedem wochentag etwas eingereicht wurde
    end
  end

  def unchecked
    @instructors = User.joins(:role).where( :roles => {:check => true} )
    #für jeden Ausbilder, der nicht deaktiviert ist
    @instructors.each do |instructor|
      if instructor.deleted != true
        @unchecked_reports_num = 0
        #gehe durch alle Azubis, die nicht deaktiviert sind
        instructor.apprentices.each do |apprentice|
          if apprentice.deleted != true
            #für all ihre Berichte
            apprentice.reports.each do |report|
              #if report was commited before period
              if report.status.stype == Status.commited && report.status.updated_at < Time.now - instructor_period
                @unchecked_reports_num += 1
              end
            end
          end
        end
        #if instructor has unchecked reports, which are older than the period, send email
        if @unchecked_reports_num > 0
          @data = { :instructor => instructor, :unchecked_reports_num => @unchecked_reports_num }
          UserMailer.unchecked_reports_mail(@data).deliver
        end
      end
    end
  end
end
