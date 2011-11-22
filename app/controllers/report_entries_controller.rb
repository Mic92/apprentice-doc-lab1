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
    @entry = ReportEntry.new
  end

  def edit
    @report = Report.find(params[:report_id])
    @entry = ReportEntry.find(params[:id])
    @hours =  @entry.duration_in_hours.to_i
    @minutes = ((@entry.duration_in_hours.hours / 1.minute) % 60).to_i
  end

  def create
    @report = Report.find(params[:report_id])
    if params[:hours] != nil && params[:minutes] != nil && params[:report_entry] != nil
      @duration = (params[:hours].to_i.hours + params[:minutes].to_i.minutes) / 1.0.hour
      @entry = @report.report_entries.build({ :duration_in_hours => @duration }.merge(params[:report_entry]))
    else
      @entry = @report.report_entries.build(params[:report_entry])
    end

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
