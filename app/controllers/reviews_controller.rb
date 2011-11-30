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
    if current_user.role.commit?
      @report = Report.find(params[:id])
      @report.status.stype = Status.commited
      @report.status.save
      redirect_to reports_path, :notice => 'Das Freigeben des Berichtes war erfolgreich.' and return
    elsif current_user.role.check?
      redirect_to welcome_path and return
    end
    redirect_to welcome_path and return
  end

  def update
    if current_user.role.commit?
      redirect_to welcome_path and return
    elsif current_user.role.check?


      redirect_to reports_path, :notice => 'Diese Funktion ist noch in Arbeit.' and return
    end
    redirect_to welcome_path and return
  end

  def destroy
    if current_user.role.commit?


      redirect_to reports_path, :notice => 'Diese Funktion ist noch in Arbeit.' and return
    elsif current_user.role.check?


      redirect_to reports_path, :notice => 'Diese Funktion ist noch in Arbeit.' and return
    end
    redirect_to welcome_path and return
  end

end
