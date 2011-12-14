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
  def self.instructor_period
    2.weeks
  end

  def self.apprentice_period_inmonths
    12
  end

  def workdays (startdate, enddate)
    #TODO richtige tagesberechnung
    enddate.yday - startdate.yday
  end

  def unwritten
    @apprentices = User.joins(:role).where( :roles => {:commit => true} )
    @year = Time.now.year
    @month = Time.now.month
    #@day = Time.now.day

    @apprentices.each do |apprentice|
      if apprentice.deleted != true

        i = 1
        @date_v = Time.now
        #@year_v = @year
        #@month_v = @month
        #get commited and accepted reports
        @reports = apprentice.reports.select {|report| report.status.stype == Status.commited || report.status.stype == Status.accepted }
        @date_array = []
        #gehe durch jeden monat, der im zurückliegendem zeitraum liegt
        while i < ReportBotController.apprentice_period_inmonths + 1
          @date_v -= 1.months
          @vtime_start = Time.mktime(@date_v.year, @date_v.month)
          @vtime_end = Time.mktime(@date_v.year, @date_v.month) + 1.months
          #berechne, wie viele Arbeitstage in dem zu prüfendem Monat sind
          @daycount = workdays( @vtime_start, @vtime_end )
          #ziehe von dem Arbeitstagcounter die Tage ab, für die ein Report existiert
          @reports.each do |report|
            if report.period_start.to_time >= @vtime_start && report.period_end.to_time <= @vtime_end
              #Report ist innerhalb des Monats
              @daycount -= workdays( report.period_start.to_time, report.period_end.to_time )
            elsif report.period_start.to_time < @vtime_start && report.period_end.to_time <= @vtime_end
              #Report ist teilweise am Anfang des Monats
              @daycount -= workdays( @vtime_start, report.period_end.to_time )
            elsif report.period_start.to_time >= @vtime_start && report.period_end.to_time > @vtime_end
              #Report ist teilweise am Ende des Monats
              @daycount -= workdays( report.period_start.to_time, @vtime_end )
            end
          end
          if @daycount > 0
            @date_array << [@date_v.year, @date_v.month]
          end
          i += 1
        end
        #whileloop ist zu ende, email mit monaten senden, für die ein bericht fehlt
        if @date_array != []
          @data = { :apprentice => apprentice, :date_array => @date_array }
          UserMailer.unwritten_reports_mail(@data).deliver  #TODO richtige mail schreiben
        end
      end
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
              if report.status.stype == Status.commited && report.status.updated_at < Time.now - ReportBotController.instructor_period
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
