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

# Ist für die Zuweisung von Azubis zu Ausbildern zuständig.
class ApprenticeshipsController < ApplicationController
  # Weist dem eingeloggten Benuter den übergebenen Benutzer als Auszubildenden zu und
  # leitet auf UsersController#index weiter.
  def create
    if @apprentice = User.find_by_id(params[:apprentice_id])
      current_user.apprentices << @apprentice
      redirect_to users_path, :notice => 'Der Auszubildende wurde zugewiesen.'
    else
      redirect_to users_path, :notice => 'Der Auszubildende konnte nicht zugewiesen werden.'
    end
  end

  # Entfernt die Zuweisung des übergebenen Benutzers zum eingeloggten Benutzer und leitet
  # auf UsersController#index weiter.
  def destroy
    if @apprentice = User.find_by_id(params[:id])
      current_user.apprentices.delete(@apprentice)
      redirect_to users_path, :notice => 'Die Zuweisung wurde entfernt.'
    else
      redirect_to users_path, :notice => 'Die Zuweisung konnte nicht entfernt werden.'
    end
  end
end
