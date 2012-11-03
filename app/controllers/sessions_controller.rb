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
  
  before_filter :authenticate, :only => [ :show, :destroy ]
  
  def new
    if signed_in?
      redirect_to welcome_path
    else
      @title = "Login"
      if params[:session_email] != nil && params[:session_password] != nil
        user = User.authenticate(params[:session_email], params[:session_password])
        sign_in user
      end
    end
  end

  def create
  
    user = User.authenticate(params[:session][:email], params[:session][:password])
  
    if user.nil? or user.deleted == true 
      error_msg = "Inkorrekte Email/Passwort Kombination"
      respond_to do |format|
        format.html do
          @title = "Login"
          flash.now[:error] = error_msg
          render 'new'
        end
        format.json { render json: { error: error_msg }, status: :unprocessable_entity }
      end
    else
      # Einloggen und zur Reportuebersichtsseite leiten
      sign_in user
      respond_to do |format|
        format.html { redirect_to welcome_path }
        format.json { render json: user, except: [:hashed_password, :salt, :deleted,
          :pw_expired_at, :pw_recovery_hash, :role_id, :template_id]}
      end
    end
  
  end
  
  def show
    render 'show'
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end

end
