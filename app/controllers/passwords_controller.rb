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
  # Zeigt das Formular zum generieren eines neuen Passworts.
  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user

      @user.pw_recovery_hash = Digest::SHA2.hexdigest("#{@user.email}--#{Time.now.utc}")
      @user.pw_expired_at = (Time.now) + 600
      @user.save

      @data = { :user => @user, :domain => request.host_with_port }
      UserMailer.password_verification_mail(@data).deliver

    end

    redirect_to root_path, :notice => 'Eine Benachrichtigung wurde verschickt.'
  end


  # Setzt das Passwort des übergebenen Benutzers auf ein zufälliges Neues und
  # sendet es per Mail.
  def show
    @user = User.find_by_pw_recovery_hash(params[:id])

    if !@user.nil?
      if Time.now - @user.pw_expired_at < 0
        @password = PasswordsController.random_password

        @user.password = @password
        @user.password_confirmation = @password
        @user.save

        UserMailer.password_recovery_mail(@user, @password).deliver

        @user.pw_expired_at = Time.now
        @user.save

        redirect_to root_path, :notice => 'Ein zufälliges Passwort wurde erstellt und Ihnen per Mail zugesendet.'
      else
        redirect_to root_path, :alert => 'Der Link zum Passwortzurücksetzen ist abgelaufen. Fordern Sie bitte ein neues an.'
      end
    end
  end

  private
    # Erzeugt ein zufälliges Passwort der Länge 8, bestehend aus Ziffer, Groß- und Kleinbuchstaben.
    def self.random_password
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      newpass = ""
      1.upto(8) { |i| newpass << chars[rand(chars.size-1)] }  
      
      return newpass
    end
end
