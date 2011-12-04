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

class ReviewsController < ApplicationController
  def create
    @report = Report.find(params[:report_id])
    if current_user.role.commit? && @report.status.stype == Status.personal && current_user == @report.user
      if @report.status.comment != '' && @report.status.comment != nil
        @report.status.comment = "Dieser Bericht wurde damals aus folgendem Grund abgelehnt:\n" + @report.status.comment
      end
      @report.status.stype = Status.commited
      @report.status.save
      redirect_to reports_path, :notice => 'Das Freigeben des Berichtes war erfolgreich.' and return
    elsif current_user.role.check?
      redirect_to welcome_path and return
    end
    if current_user.role.commit? && @report.status.stype == Status.rejected
      redirect_to reports_path, :alert => 'Der Bericht muss geändert werden, bervor Sie ihn wieder vorlegen können' and return
    end
    redirect_to welcome_path and return
  end

  def edit
    @report = Report.find(params[:id])
    @status = @report.status

  end

  def update
    @report = Report.find(params[:id])
    @status = @report.status
    if current_user.role.commit?
      redirect_to welcome_path and return
    elsif current_user.role.check? && @status.stype == Status.commited
      if params[:status][:comment] != "" && @status.update_attributes(params[:status])
        @status.stype = Status.rejected
        @status.save
        redirect_to reports_path, :notice => 'Das Ablehnen des Berichtes war erfolgreich.' and return
      else
        redirect_to edit_review_path(@report), :alert => 'Das Ablehnen des Berichtes hat fehlgeschlagen, Kommentar muss abgegeben werden.' and return
      end
    end
    redirect_to welcome_path and return
  end

  def destroy
    @report = Report.find(params[:id])
    if current_user.role.commit? && @report.status.stype == Status.commited && current_user == @report.user
      if @report.status.comment != '' && @report.status.comment != nil
        @report.status.comment = @report.status.comment.from(59)
      end
      @report.status.stype = Status.personal
      @report.status.save
      redirect_to reports_path, :notice => 'Das zurückziehen des Berichtes war erfolgreich.' and return
    elsif current_user.role.check? && @report.status.stype == Status.commited
      @report.status.stype = Status.accepted
      @report.status.comment = ''
      @report.status.save
      redirect_to reports_path, :notice => 'Das annehmen des Berichtes war erfolgreich.' and return
    end
    redirect_to welcome_path and return
  end

end
