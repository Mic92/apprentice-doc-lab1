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

  def monthname (month)
    case month
      when 1
        'Januar'
      when 2
        'Februar'
      when 3
        'März'
      when 4
        'April'
      when 5
        'Mai'
      when 6
        'Juni'
      when 7
        'Juli'
      when 8
        'August'
      when 9
        'September'
      when 10
        'Oktober'
      when 11
        'November'
      when 12
        'Dezember'
      else
        'ERROR, ' + month.to_s + ' is not a month'
    end
  end

  def workdays (startdate, enddate)
    @days = Date.new(enddate.year, enddate.month, enddate.day).ld - Date.new(startdate.year, startdate.month, startdate.day).ld
    if @days < 0
      @days = 'ERROR, wrong order of dates'
    end
    case startdate.wday
      when 1  #monday
        if @days <= 5
          @w_days = @days
        else
          @w_days = 0
          while @days > 5
            @days -= 7
            @w_days += 5
          end
          if @days > 0
            @w_days += @days
          end
        end
      when 2  #tuesday
        if @days <= 4
          @w_days = @days
        else
          @w_days = 4
          @days -= 6
          while @days > 5
            @days -= 7
            @w_days += 5
          end
          if @days > 0
            @w_days += @days
          end
        end
      when 3  #wednesday
        if @days <= 3
          @w_days = @days
        else
          @w_days = 3
          @days -= 5
          while @days > 5
            @days -= 7
            @w_days += 5
          end
          if @days > 0
            @w_days += @days
          end
        end
      when 4  #thursday
        if @days <= 2
          @w_days = @days
        else
          @w_days = 2
          @days -= 4
          while @days > 5
            @days -= 7
            @w_days += 5
          end
          if @days > 0
            @w_days += @days
          end
        end
      when 5  #friday
        if @days <= 1
          @w_days = @days
        else
          @w_days = 1
          @days -= 3
          while @days > 5
            @days -= 7
            @w_days += 5
          end
          if @days > 0
            @w_days += @days
          end
        end
      when 6  #saturday
        @w_days = 0
        @days -= 2
        while @days > 5
          @days -= 7
          @w_days += 5
        end
        if @days > 0
          @w_days += @days
        end
      when 0  #sunday
        @w_days = 0
        @days -= 1
        while @days > 5
          @days -= 7
          @w_days += 5
        end
        if @days > 0
          @w_days += @days
        end
      else
        @w_days = 'ERROR'
    end
    @w_days
  end

  def unwritten
    if request.remote_ip == "127.0.0.1"
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
              @date_array << [@date_v.year, monthname(@date_v.month)]
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
            @date_array << [apprentice.trainingbegin.to_time.year, monthname(apprentice.trainingbegin.to_time.month)]
          end
          #email mit monaten senden, für die ein bericht fehlt
          if @date_array != []
            @data = { :apprentice => apprentice, :date_array => @date_array }
            UserMailer.unwritten_reports_mail(@data).deliver
          end
        end
        if apprentice.deleted != true && apprentice.trainingbegin == nil
          @data = { :user => apprentice }
          UserMailer.unset_trainingsbegin_mail(@data).deliver
        end
      end
    else
      redirect_to welcome_path and return
    end
  end

  def unchecked
    if request.remote_ip == "127.0.0.1"
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
    else
      redirect_to welcome_path and return
    end
  end
end
