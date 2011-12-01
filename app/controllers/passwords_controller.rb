# encoding: utf-8
#--
# Copyright (C) 2011, Dominik Cermak <d.cermak@arcor.de>
# Copyright (C) 2011, Marcus Hänsch <haensch.marcus@gmail.com>
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

# Ist für das zurücksetzen von Passwörtern zuständig.
class PasswordsController < ApplicationController
  before_filter :authenticate
  before_filter :admin

  # Setzt das Passwort des übergebenen Benutzers auf ein zufälliges Neues und
  # sendet es per Mail.
  def update
    @user = User.find(params[:id])
    @password = random_password

    @user.password = @password
    @user.password_confirmation = @password
    @user.save

    @data = { :user => @user, :password => @password }

    UserMailer.password_recovery_mail(@data).deliver

    redirect_to users_path, :notice => 'Ein zufälliges Passwort wurde erstellt.'
  end

  private
    # Erzeugt ein zufälliges Passwort der Länge 8, bestehend aus Ziffer, Groß- und Kleinbuchstaben.
    def random_password
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      newpass = ""
      1.upto(8) { |i| newpass << chars[rand(chars.size-1)] }
      return newpass
    end
end
