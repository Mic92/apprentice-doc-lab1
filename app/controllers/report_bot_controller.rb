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

    @apprentices.each do |apprentice|
      if apprentice.deleted != true && apprentice.trainingbegin != nil
        i = 1
        @date_v = Time.mktime(@year, @month)
        #get commited and accepted reports
        @reports = apprentice.reports.select {|report| report.status.stype == Status.commited || report.status.stype == Status.accepted }
        @date_array = []
        #gehe durch jeden monat, der im zurückliegendem zeitraum liegt
        while i < ReportBotController.apprentice_period_inmonths + 1 && apprentice.trainingbegin.to_time < @date_v - 1.months
          @date_v -= 1.months
          #berechne, wie viele Arbeitstage in dem zu prüfendem Monat sind
          @daycount = workdays( @date_v, @date_v + 1.months)
          #ziehe von dem Arbeitstagcounter die Tage ab, für die ein Report existiert
          @reports.each do |report|
            @r_start = report.period_start.to_time
            @r_end = report.period_end.to_time + 1.days
            # + 1.days weil der period_end Eintrag um 1 Tag abweicht, da es den Tag symbolisiert und nicht die wirkliche zeitliche Endgrenze
            if @r_start >= @date_v && @r_end <= @date_v + 1.months
              #Report ist innerhalb des Monats
              @daycount -= workdays( @r_start, @r_end)
            elsif @r_start < @date_v && @r_end > @date_v + 1.months
              #Report umfasst den Zeitraum
              @daycount -= workdays( @date_v, @date_v + 1.months)
            elsif @r_start < @date_v && @r_end > @date_v
              #Report ist teilweise am Anfang des Monats
              @daycount -= workdays( @date_v, @r_end)
            elsif @r_start < @date_v + 1.months && @r_end > @date_v + 1.months
              #Report ist teilweise am Ende des Monats
              @daycount -= workdays( @r_start, @date_v + 1.months )
            end
          end
          if @daycount > 0
            @date_array << [@date_v.year, @date_v.month]
          end
          i += 1
        end
        #whileloop ist zu ende, für den verbleibenden Zeitraum, anfangend vom Ausbildungsbeginn prüfen
        @daycount = workdays( apprentice.trainingbegin.to_time, @date_v)
        @reports.each do |report|
          @r_start = report.period_start.to_time
          @r_end = report.period_end.to_time + 1.days
          # + 1.days weil der period_end Eintrag um 1 Tag abweicht, da es den Tag symbolisiert und nicht die wirkliche zeitliche Endgrenze
          if @r_start >= apprentice.trainingbegin.to_time && @r_end <= @date_v
            #Report ist innerhalb des Monats
            @daycount -= workdays( @r_start, @r_end)
          elsif @r_start < apprentice.trainingbegin.to_time && @r_end > @date_v
            #Report umfasst den Zeitraum
            @daycount -= workdays( apprentice.trainingbegin.to_time, @date_v)
          elsif @r_start < apprentice.trainingbegin.to_time && @r_end > apprentice.trainingbegin.to_time
            #Report ist teilweise am Anfang des Monats
            @daycount -= workdays( apprentice.trainingbegin.to_time, @r_end)
          elsif @r_start < @date_v && @r_end > @date_v
            #Report ist teilweise am Ende des Monats
            @daycount -= workdays( @r_start, @date_v )
          end
        end
        if @daycount > 0
          @date_array << [apprentice.trainingbegin.to_time.year, apprentice.trainingbegin.to_time.month]
        end
        #email mit monaten senden, für die ein bericht fehlt
        if @date_array != []
          @data = { :apprentice => apprentice, :date_array => @date_array }
          UserMailer.unwritten_reports_mail(@data).deliver  #TODO richtige mail schreiben
        end
      end
      if apprentice.deleted != true && apprentice.trainingbegin == nil
        #TODO Mail schreiben, dass Ausbildungsbegin leer ist
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
