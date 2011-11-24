# encoding: utf-8
#
# Copyright (C) 2011, Sascha Peukert <sascha.peukert@gmail.com>
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

class SessionsController < ApplicationController
  def new
    @title = "Login"
  end

  def create
  
    user = User.authenticate(params[:session][:email], params[:session][:password])
	
    if user.nil?
      # Fehlermeldung
      flash.now[:error] = "Inkorrekte Email/Passwort Kombination"
      @title = "Login"
      render 'new'
	else
      # Einloggen und zur Reportuebersichtsseite leiten
	  sign_in user
      redirect_to report
    end
  
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
