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

# Ist für die Interaktion mit Einträgen zuständig.
#
# Nur eingeloggte Benutzer können seine Funktionalität nutzen,
# des weiteren benötigen sie das Freigeben-Recht (commit) für alle Aktionen.
# Wurde der Bericht schon akzeptiert, kann keine Aktion ausgeführt werden.
class ReportEntriesController < ApplicationController
  #before_filter :authenticate
  #before_filter :correct_user
  #before_filter :commit
  #before_filter :not_accepted

  # Zeigt das Formular zum Erstellen eines neuen Eintrags.
  def new
    @report = Report.find(params[:report_id])
    @entry = ReportEntry.new
    # Setze die Werte, mit denen die Felder vorausgefüllt werden.
    @hours = 1
    @minutes = 30
  end

  # Zeigt das Formular zum Bearbeiten eines vorhandenen Eintrags. Wandelt die Dauer von Stunden in
  # Stunden und Minuten um.
  def edit
    @report = Report.find(params[:report_id])
    @entry = ReportEntry.find(params[:id])
    # Das Formular hat eine Auswahl für die Stunden und eine für die Minuten.
    @hours =  @entry.duration_in_hours.to_i
    @minutes = ((@entry.duration_in_hours.hours / 1.minute) % 60).to_i
  end

  # Legt einen neuen Eintrag an. Wandelt die Dauer von Stunden und Minuten in Stunden um.
  # Leitet auf ReportsController#show weiter. Ist der Eintrag nicht valid, so wird das Formular
  # erneut angezeigt.
  def create
    @report = Report.find(params[:report_id])
    if params[:hours] != nil && params[:minutes] != nil && params[:report_entry] != nil
      # Das Formular liefert die Dauer nach Stunden und Minuten getrennt, das Model benötigt aber die Dauer
      # nur in Stunden.
      @duration = (params[:hours].to_i.hours + params[:minutes].to_i.minutes) / 1.0.hour
      # Priorisiere duration_in_hours über die berechnete Dauer.
      @entry = @report.report_entries.build({ :duration_in_hours => @duration }.merge(params[:report_entry]))
    else
      @entry = @report.report_entries.build(params[:report_entry])
    end

    if @entry.date != nil
      # Einträge müssen im Zeitraum des Berichts liegen.
      if @entry.date.to_date >= @report.period_start && @entry.date.to_date <= @report.period_end
        if @entry.save
          # Der Status des Berichts wird durch das Erstellen wieder auf personal gesetzt, damit er wieder
          # freigegeben werden kann.
          @report.status.update_attributes(:stype => Status.personal)
          redirect_to @report, :notice => 'Eintrag wurde erfolgreich erstellt.' and return
        end
      else
        @entry.errors.add(:date, 'muss im Zeitraum des Berichts liegen')
      end
    end

    render 'new'
  end

  # Ändert die Attribute des Eintrags und leitet auf ReportsController#show weiter.
  # Sind die Attribute nicht valid, so wird das Formular erneut angezeigt.
  def update
    @report = Report.find(params[:report_id])
    @entry = ReportEntry.find(params[:id])

    if params[:hours] != nil && params[:minutes] != nil && params[:report_entry] != nil
      # Das Formular liefert die Dauer nach Stunden und Minuten getrennt, das Model benötigt aber die Dauer
      # nur in Stunden.
      @duration = (params[:hours].to_i.hours + params[:minutes].to_i.minutes) / 1.0.hour
      @attr = { :duration_in_hours => @duration }.merge(params[:report_entry])
    else
      @attr = params[:report_entry]
    end

    if @attr != nil
      # Erzeuge aus den Formulardaten das Datum zum vergleichen.
      @date = ReportEntry.new(@attr).date
      if @date != nil
        # Einträge müssen im Zeitraum des Berichts liegen.
        if @date >= @entry.report.period_start && @date <= @entry.report.period_end
          if @entry.update_attributes(@attr)
            # Der Status des Berichts wird durch das Bearbeiten wieder auf personal gesetzt, damit er wieder
            # freigegeben werden kann.
            @entry.report.status.update_attributes(:stype => Status.personal)
            redirect_to @entry.report, :notice => 'Eintrag wurde erfolgreich bearbeitet.' and return
          end
        else
          @entry.errors.add(:date, 'muss im Zeitraum des Berichts liegen')
        end
      end
    end

    render 'edit'
  end

  # Löschte einen Eintrag aus dem System und leitet auf ReportsController#show weiter.
  def destroy
    @entry = ReportEntry.find(params[:id])
    @report = @entry.report
    @entry.destroy
    # Der Status des Berichts wird durch das Löschen wieder auf personal gesetzt, damit er wieder
    # freigegeben werden kann.
    @report.status.update_attributes(:stype => Status.personal)

    redirect_to @report, :notice => 'Eintrag wurde erfolgreich gelöscht.'
  end

  private
    # Leitet den Benutzer auf die Willkommen-Seite, falls er nicht der Besitzer des Berichts ist.
    def correct_user
      @user = Report.find(params[:report_id]).user
      redirect_to welcome_path unless current_user?(@user)
    end

    # Leitet den Benutzer auf die Berichtsübersicht-Seite, wenn der Bericht akzeptiert ist.
    def not_accepted
      @report = Report.find(params[:report_id])
      redirect_to @report, :alert => 'Da der Bericht schon akzeptiert wurde sind Änderungen nicht mehr möglich' if @report.status.stype == Status.accepted
    end
end
