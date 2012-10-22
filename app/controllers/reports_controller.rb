# encoding: utf-8
#--
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
#++

# Ist für die Interaktion mit den Berichten zuständig.
#
# Nur eingeloggte Benutzer können seine Funktionalität nutzen,
# des weiteren benötigen sie das Lesen-Recht (read) für #index und #show
# und das Freigeben-Recht (commit) für #new, #create, #update, #destroy.
# #edit, #update und #destroy darf nur vom Autor ausgeführt werden.
# #show erfordert entweder den Autor, oder einen freigegebenen Bericht und einen Ausbilder.
# Berichte die freigegeben oder bereits akzeptiert wurden, können nicht mehr bearbeitet werden.
# Hat ein Benutzer Ausbildungsbeginn oder Ausbildungsjahr nicht gesetzt, so kann er keine
# Berichte anlegen, bzw. bearbeiten.
class ReportsController < ApplicationController
	
  before_filter :authenticate
  before_filter :read, :only => [ :index, :show ]
  before_filter :correct_user_or_instructor, :only => :show
  before_filter :commit, :only => [ :new, :create, :update, :destroy ]
  before_filter :not_commited, :only => [ :edit, :update, :destroy ]
  before_filter :not_accepted, :only => [ :edit, :update ]
  before_filter :correct_user, :only => [ :edit, :update, :destroy, :show ]
  before_filter :trainingbegin_and_year_set, :only => [ :create, :update ]

  # Listet Berichte auf. Welche Bericht angezeigt werden hängt von den Rechten des
  # Benutzers ab:
  # * Freigeben (commit): alle Berichte des Benutzers
  # * Prüfen (check): alle Berichte der dem Benutzer zugewiesenen Azubis oder alle freigegebenen Berichte aller Azubis wenn der Parameter all == true
  def index
    setupPager(current_user.reports,params)
    if current_user.role.commit?
      @reports = pager(current_user.reports).order('period_start asc, period_end asc')
    elsif current_user.role.check?
      if params[:all]
        @reports = Report.joins(:status).where(:statuses => { :stype => Status.commited }).order('period_start asc, period_end asc')
      else
        @reports = Report.joins(:status, :user).where(:statuses => { :stype => Status.commited }, :user_id => current_user.apprentices).order('period_start asc, period_end asc')
      end
    end

	respond_to do |format|
       format.html
       format.json { render json: @reports }
    end

  end

  # Zeigt die Einträge eines Berichts.
  def show
    @report = Report.find(params[:id])
    @entries = @report.report_entries.order('date asc')
    
    respond_to do |format|
       format.html
       format.json { render json: @entries, except: [:duration_in_hours] }
    end
  end

  # Zeigt das Formular zum Erstellen eines neuen Berichts.
  def new
    @report = Report.new
    # Setze die Werte, mit denen die Felder vorausgefüllt werden.
    @date = Date.today.beginning_of_day

    if not current_user.template.nil?
      codegroup = current_user.template.code.codegroup
      if codegroup == PrintReportsHelper::DAILY
        @date = @date.beginning_of_week
      elsif codegroup == PrintReportsHelper::WEEKLY
        @date = @date.beginning_of_month.beginning_of_week
      end
    end

    @report.period_start = @date
    
      respond_to do |format|
       format.html
       format.json { render json: @report }
    end
  end

  # Zeigt das Formular zum Bearbeiten eines vorhandenen Berichts.
  def edit
    @report = Report.find(params[:id])
    
    respond_to do |format|
       format.html
       format.json { render json: @report }
    end
    
  end

  # Legt einen neuen Bericht, sowie dessen initialen Status an und leitet auf #index weiter.
  # Ist der Bericht nicht valid, so wird das Formular erneut gezeigt.
  def create
  
    @report = current_user.reports.build(params[:report])
    #@report = reports.build(params[:report])
    # Jeder Bericht muss einen Status haben, also erstelle ihn zusammen mit dem Bericht.
    @report.build_status(:stype => Status.personal)
    @report.reportnumber = current_user.reports.count + 1
    if !@report.period_start.nil?
      @report.period_end = calc_period_end(@report.period_start)

      if no_time_overlap(@report,@report,false) && period_valid(@report,@report)
        if @report.save
          redirect_to reports_path, :notice => 'Bericht wurde erfolgreich erstellt.'
        else
          render 'new'
        end
      else
        render 'new'
      end
    else
      render 'new'
    end
  end

  # Ändert die Attribute des Berichts und leitet auf #index weiter.
  # sind die Attribute nicht valid, so wird das Formular erneut gezeigt.
  def update
    @report = Report.find(params[:id])
    
    # Hilfsobjekt für den Vergleich der Daten.
    @new = Report.new(params[:report])

    if @new.period_start != nil
      @new.period_end = calc_period_end(@new.period_start)
      @shift = (@new.period_start - @report.period_start)

      if no_time_overlap(@new,@report,true) && period_valid(@new,@report)
        if params[:report] != nil && @report.update_attributes(params[:report].merge(:period_end => @new.period_end))
          @report.report_entries.each { |e| e.update_attribute(:date, (e.date + @shift.days)) }
          # Der Status des Berichts wird durch das Bearbeiten wieder auf personal gesetzt, damit er wieder
          # freigegeben werden kann.
          @report.status.update_attributes(:stype => Status.personal)
          redirect_to reports_path, :notice => 'Bericht wurde erfolgreich bearbeitet.'
        else
          render 'edit'
        end
      else
        render 'edit'
      end
    else
      render 'edit'
    end
  end

  # Löscht einen Bericht aus dem System und leitet auf #index weiter.
  def destroy
    @report = Report.find(params[:id])
    @report.destroy

    redirect_to reports_path, :notice => 'Bericht wurde erfolgreich gelöscht.'
  end

  private
    # Leitet den Benutzer auf die Willkommen-Seite, falls er nicht der Besitzer des Berichts ist.
    def correct_user
      user = Report.find(params[:id]).user
      redirect_to welcome_path unless current_user?(user)
    end

    # Leitet den Benutzer auf die Willkommen-Seite, außer er ist der Autor des Berichts oder der Bericht ist freigegeben und der Benutzer
    # ist ein Ausbilder.
    def correct_user_or_instructor
      report = Report.find(params[:id])
      redirect_to welcome_path, :alert => 'Sie haben nicht die Berechtigung diesen Bericht anzuzeigen.' unless current_user?(report.user) || (report.status.stype == Status.commited && current_user.role.check?)
    end

    # Leitet den Benutzer auf die Berichtsübersicht-Seite, wenn der Bericht akzeptiert ist.
    def not_accepted
      report = Report.find(params[:id])
      redirect_to reports_path, :alert => 'Da der Bericht schon akzeptiert wurde, sind Änderungen nicht mehr möglich.' if report.status.stype == Status.accepted
    end

    # Leitet den Benutzer auf die Berichtsübersicht-Seite, wenn der Bericht freigegeben ist.
    def not_commited
      report = Report.find(params[:id])
      redirect_to reports_path, :alert => 'Da der Bericht freigegeben wurde, sind Änderungen nicht mehr möglich.' if report.status.stype == Status.commited
    end

    # Leitet den Benutzer auf die Berichtsübersicht-Seite, wenn kein Ausbildungsbeginn oder Ausbildungsjahr gesetzt ist.
    def trainingbegin_and_year_set
      redirect_to reports_path, :alert => 'Um diese Aktion durchführen zu können müssen sowohl Ausbildungsbeginn als auch Ausbildungsjahr gesetzt sein.' if current_user.trainingbegin.nil? or current_user.trainingyear.nil?
    end

    # Validiert, dass es keine zeitlichen Überschneidungen zwischen Berichten gibt.
    def no_time_overlap(report,error_report,update)
      if report.period_start and report.period_end
        reports = current_user.reports.where("(period_start <= :period_start AND period_end >= :period_start) OR
                                             (period_start <= :period_end AND period_end >= :period_end) OR
                                             (period_start >= :period_start AND period_end <= :period_end )",
                                             :period_start => report.period_start,
                                             :period_end => report.period_end)
        if reports.length > 0
          if update && reports.length == 1 && reports.first.id == error_report.id
            return true
          end
          error_report.errors[:base] << 'Es darf keine zeitlichen Überlappungen mit anderen Berichten geben.'
          return false
        else
          return true
        end
      end
      return false
    end

    # Validiert, dass der Zeitraum im Bereich Ausbildungsbeginn bis Ausbildungsbeginn + Ausbildungsjahr liegt
    def period_valid(report,error_report)
      if report.period_start and report.period_end and current_user.trainingbegin and current_user.trainingyear
        period_start = report.period_start
        period_end = report.period_end
        min_date = current_user.trainingbegin
        max_date = min_date + current_user.trainingyear.years

        if period_start >= min_date && period_start <= max_date && period_end >= min_date && period_end <= max_date
          return true
        end

        error_report.errors[:base] << 'Der Bericht muss in Ihrem Ausbildungszeitraum liegen.'
        return false
      end
      return false
    end

    # Berechnet das Enddatum des Zeitraums in Abhängigkeit des Templates
    def calc_period_end(period_start)
      period_end = period_start

      if not current_user.template.nil?
        codegroup = current_user.template.code.codegroup
        if codegroup == PrintReportsHelper::HOURLY
          # nothing to do
        elsif codegroup == PrintReportsHelper::DAILY
          period_end = period_start + 1.week - 1.day
        elsif codegroup == PrintReportsHelper::WEEKLY
          period_end = period_start + 5.weeks - 1.day
        end
      end
      return period_end
    end
end
