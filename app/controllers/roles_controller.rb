# encoding: utf-8
#
# Copyright (C) 2011, Marcus Hänsch <haensch.marcus@gmail.com>
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

class RolesController < ApplicationController

  before_filter :authenticate
  before_filter :admin

  def index
    @roles = Role.all
  end

  def new
    @role = Role.new
  end

  def edit
    @role = Role.find(params[:id])
  end

  def create
    @role = Role.new(params[:role])

      if @role.save
        redirect_to roles_path, :notice => "Das Rechte-Profil #{@role.name} wurde erfolgreich erstellt."
      else
        render 'new'
      end
  end

  def update
    @role = Role.find(params[:id])
    if params[:role] != nil
      if (params[:id].to_i == current_user.role_id) && (params[:role][:admin].to_i == 0)
        flash.now[:error] = "Das Administrator-Recht kann nicht selbst entfernt werden!"
        render 'edit'          
      elsif @role.update_attributes(params[:role])   
          redirect_to roles_path, :notice => "Das Rechte-Profil #{@role.name} wurde erfolgreich bearbeitet."
        else
          flash.now[:error] = "Es ist ein Fehler aufgetreten"
          render 'edit'
        end
    else
      flash.now[:error] = "Es ist ein Fehler aufgetreten"
      render 'edit'
    end
  end

  def destroy
    @role = Role.find(params[:id])
    if @role.users == []
      @role.destroy
      redirect_to roles_path, :notice => "Das Rechte-Profil wurde erfolgreich entfernt."
    else
      redirect_to roles_path, :notice => "Das Rechte-Profil konnte nicht entfernt werden, da ihm Benutzer zugewiesen sind."
    end
  end
  
end
