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
class ReportsController < ApplicationController
  before_filter :authenticate
  before_filter :read, :only => [ :index, :show ]
  before_filter :correct_user_or_instructor, :only => :show
  before_filter :commit, :only => [ :new, :create, :update, :destroy ]
  before_filter :correct_user, :only => [ :edit, :update, :destroy ]

  # Listet Berichte auf. Welche Bericht angezeigt werden hängt von den Rechten des
  # Benutzers ab:
  # * Freigeben (commit): alle Berichte des Benutzers
  # * Prüfen (check): alle Berichte der dem Benutzer zugewiesenen Azubis
  def index
    if current_user.role.commit?
      @reports = current_user.reports.order('period_start asc, period_end asc')
    elsif current_user.role.check?
      if params[:all]
        @reports = Report.joins(:status).where(:statuses => { :stype => Status.commited }).order('period_start asc, period_end asc')
      else
        @reports = Report.joins(:status, :user).where(:statuses => { :stype => Status.commited }, :user_id => current_user.apprentices).order('period_start asc, period_end asc')
      end
    end
  end

  # Zeigt die Einträge eines Berichts.
  def show
    @report = Report.find(params[:id])
    @entries = @report.report_entries
  end

  # Zeigt das Formular zum Erstellen eines neuen Berichts.
  def new
    @report = Report.new
  end

  # Zeigt das Formular zum Bearbeiten eines vorhandenen Berichts.
  def edit
    @report = Report.find(params[:id])
  end

  # Legt einen neuen Bericht, sowie dessen initialen Status an und leitet auf #index weiter.
  # Ist der Bericht nicht valid, so wird das Formular erneut gezeigt.
  def create
    @report = current_user.reports.build(params[:report])
    @report.build_status(:stype => Status.personal)

    if @report.save
      redirect_to reports_path, :notice => 'Bericht wurde erfolgreich erstellt.'
    else
      render 'new'
    end
  end

  # Ändert die Attribute des Berichts und leitet auf #index weiter.
  # sind die Attribute nicht valid, so wird das Formular erneut gezeigt.
  def update
    @report = Report.find(params[:id])

    if params[:report] != nil && @report.update_attributes(params[:report])
      @report.status.update_attributes(:stype => Status.personal)
      redirect_to reports_path, :notice => 'Bericht wurde erfolgreich bearbeitet.'
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
      @user = Report.find(params[:id]).user
      redirect_to welcome_path unless current_user?(@user)
    end

    # Leitet den Benutzer auf die Willkommen-Seite, außer er ist der Autor des Berichts oder der Bericht ist freigegeben und der Benutzer
    # ist ein Ausbilder.
    def correct_user_or_instructor
      @report = Report.find(params[:id])
      redirect_to welcome_path unless current_user?(@report.user) || (@report.status.stype == Status.commited && current_user.role.check?)
    end
end
