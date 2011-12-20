# encoding: utf-8
#--
# Copyright (C) 2011, Sascha Peukert <sascha.peukert@gmail.com>
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

# Stellt Methoden zur Session-Verwaltung und Authentifizierung zur Verfügung.
module SessionsHelper
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  # Prüft, ob der eingeloggte Benutzer (current_user) der übergebenen Benutzer ist.
  def current_user?(user)
    user == current_user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  # Ruft deny_access auf, falls der Benutzer nicht eingeloggt ist.
  def authenticate
    deny_access unless signed_in?
  end

  # Leitet den Benutzer auf die Wurzel-Seite (Login), gibt einen Hinweis aus.
  def deny_access
    redirect_to root_path, :alert => 'Sie müssen angemeldet sein um auf diese Seite zuzugreifen.'
  end

  # Definiert den Hinweis, der bei fehlenden Rechten ausgegeben wird.
  def right_notice
    'Sie haben nicht die benötigten Rechte für diese Aktion.'
  end

  # Leitet den Benuter auf die Willkommen-Seite, falls er kein Lesen-Recht hat. Gibt den Hinweis right_notice aus.
  def read
    redirect_to welcome_path, :alert => right_notice unless current_user.role.read?
  end

  # Leitet den Benuter auf die Willkommen-Seite, falls er kein Freigeben-Recht hat. Gibt den Hinweis right_notice aus.
  def commit
    redirect_to welcome_path, :alert => right_notice unless current_user.role.commit?
  end

  # Leitet den Benuter auf die Willkommen-Seite, falls er kein Prüfen-Recht hat. Gibt den Hinweis right_notice aus.
  def check
    redirect_to welcome_path, :alert => right_notice unless current_user.role.check?
  end

  def export
    redirect_to welcome_path, :alert => right_notice unless current_user.role.export?
  end

  # Leitet den Benuter auf die Willkommen-Seite, falls er kein Admin-Recht hat. Gibt den Hinweis right_notice aus.
  def admin
    redirect_to welcome_path, :alert => right_notice unless current_user.role.admin?
  end
  
  def adminremovable?
    @admin_count = 0
    @roles_with_admin = Role.where(:admin => true)
    @roles_with_admin.each do |r|
      if r.users != nil
        @users  = r.users
        @users.each do |u|
          @admin_count += 1 unless u.deleted?          
        end
      end
    end
    if @admin_count > 1
      return true
    else
      return false
    end
  end

  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
end
