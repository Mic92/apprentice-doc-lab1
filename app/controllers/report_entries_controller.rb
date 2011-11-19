# encoding: utf-8
#
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

class ReportEntriesController < ApplicationController
  def new
    @report = Report.find(params[:report_id])
    @entry = @report.report_entries.build
  end

  def edit
    @entry = ReportEntry.find(params[:id])
  end

  def create
    @report = Report.find(params[:report_id])
    @entry = @report.report_entries.build(params[:report_entry])

    if @entry.save
      redirect_to @report, :notice => 'Eintrag wurde erfolgreich erstellt.'
    else
      render 'new'
    end
  end

  def update
    @entry = ReportEntry.find(params[:id])

    if params[:report_entry] != nil && @entry.update_attributes(params[:report_entry])
      redirect_to @entry.report, :notice => 'Eintrag wurde erfolgreich bearbeitet.'
    else
      render 'edit'
    end
  end

  def destroy
    @entry = ReportEntry.find(params[:id])
    @report = @entry.report
    @entry.destroy

    redirect_to @report, :notice => 'Eintrag wurde erfolgreich gelöscht.'
  end
end
