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
class ReportsController < ApplicationController
  before_filter :authenticate
  before_filter :correct_user, :only => [ :edit, :update, :destroy ]
  before_filter :read, :only => [ :index, :show ]
  before_filter :commit, :only => [ :new, :create, :update, :destroy ]

  # Listet alle Berichte auf.
  def index
    @reports = Report.all
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
    @report.build_status(:stype => 0)

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
end
