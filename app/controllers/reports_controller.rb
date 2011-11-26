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

class ReportsController < ApplicationController
  before_filter :authenticate
  before_filter :correct_user, :only => [ :edit, :update, :destroy ]
  before_filter :read, :only => [ :index, :show ]
  before_filter :commit, :only => [ :new, :create, :update, :destroy ]

  def index
    @reports = Report.all
  end

  def show
    @report = Report.find(params[:id])
    @entries = @report.report_entries
  end

  def new
    @report = Report.new
  end

  def edit
    @report = Report.find(params[:id])
  end

  def create
    @report = current_user.reports.build(params[:report])
    @report.build_status(:stype => 0)

    if @report.save
      redirect_to reports_path, :notice => 'Bericht wurde erfolgreich erstellt.'
    else
      render 'new'
    end
  end

  def update
    @report = Report.find(params[:id])

    if params[:report] != nil && @report.update_attributes(params[:report])
      redirect_to reports_path, :notice => 'Bericht wurde erfolgreich bearbeitet.'
    else
      render 'edit'
    end
  end

  def destroy
    @report = Report.find(params[:id])
    @report.destroy

    redirect_to reports_path, :notice => 'Bericht wurde erfolgreich gelöscht.'
  end

  private
    def correct_user
      @user = Report.find(params[:id]).user
      redirect_to welcome_path unless current_user?(@user)
    end
end
