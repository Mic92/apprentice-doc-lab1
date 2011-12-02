# encoding: utf-8
#
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


# UsersController ist verantwortlich für die Benutzerverwaltung. Je nach # Rechtevergabe für den Benutzer sind verschiedene Funktionalitäten zu
# berücksichtigen. 
# Die Funktionalität besteht nur für angemeldete Benutzer.

class UsersController < ApplicationController
  before_filter :authenticate
  before_filter :correct_user, :only => [ :show, :edit, :update]
# Die Methode 'index' zeigt einem Administrator alle Benutzer an, Ausbilder werden ihre Auszubildenden angezeigt.
# Für Auszubildende hat die Methode keine Verwendung und ist gesperrt.
  def index
    if current_user.role.admin?
      @users = User.all
    elsif current_user.role.check?
      @users = current_user.apprentices
      else redirect_to welcome_path
    end    
  end
# Die Methode 'show' zeigt das eigene Profil an.

  def show
    @user = current_user
  end
  
# Die Methode 'new' erzeugt einen neuen Nutzer, wenn man Administrator oder Ausbilder ist. Für Auszubildene ist die Methode gesperrt.

  def new
    if current_user.role.admin? || current_user.role.check?
      @user = User.new
    else
      redirect_to welcome_path
    end
  end
  
# Die Methode 'edit' ermöglicht das Editieren des eigenen Profils.

  def edit
    @user = User.find(params[:id])    
  end

# Die Methode 'create' erstellt einen neuen Benutzer, sofern dieser über valide Attribute verfügt.
# Administratoren dürfen jede Art von Benutzer erstellen, Ausbilder nur Auszubildende, Auszubildenden ist die Methode gesperrt.

  def create
    @user = User.new(params[:user])
    if @user == nil || @user.role_id == nil 
      render 'new'
    elsif current_user.role.admin?
        
        @user = User.create(params[:user])      
        if @user.save
          redirect_to users_path, :notice => 'Der Benutzer wurde erfolgreich erstellt.'
        else
          render 'new'
        end
      elsif current_user.role.check?
        
        @role = Role.find(@user.role_id)
        if @role.admin? || @role.check?
          render 'new'        
        else
          @user = current_user.apprentices.build(params[:user])
          if @user.save
            redirect_to users_path, :notice => 'Der Benutzer wurde erfolgreich erstellt.'
          else
            render 'new'
          end
        end
        
      else redirect_to welcome_path
    end
    
    
  end

# Die Methode 'update' aktualisiert das eigene Benutzerprofil mit validen Daten. 

  def update
    @user = current_user
    @attr = params[:user]
    if @attr == nil
      render 'edit'
    else
      @role = Role.find(@attr.fetch(:role_id))
      if current_user.role.admin?
        @user.update_attributes(@attr)
        redirect_to welcome_path, :notice => 'Das Profil wurde erfolgreich bearbeitet.'
      elsif @role.check? || @role.admin?
         render 'edit'
         else 
         @user.update_attributes(@attr)
         redirect_to welcome_path, :notice => 'Das Profil wurde erfolgreich bearbeitet.'
      end     
    end
  end


# Die Methode 'destroy' de-/aktiviert einen Benutzer. Administratoren können jeden Benutzer de-/aktivieren.
# Ausbilder können sich und ihre Auszubildenden deaktivieren, Auszubildende nur sich selbst deaktivieren.    

  def destroy
  
# Eigenen Account deaktivieren
    @user = User.find(params[:id])
    if current_user == @user
      @user.deleted = true
      @user.save!
      redirect_to root_path, :notice => 'Ihr Account wurde erfolgreich deaktiviert.'
      
# Anderen Account de-/aktivieren als Administrator
    elsif current_user.role.admin?
      if @user.deleted == false
        @user.deleted = true
        @user.save!
        redirect_to users_path, :notice => 'Der Benutzer wurde erfolgreich deaktiviert.'
      else
        @user.deleted = false
        @user.save!
        redirect_to users_path, :notice => 'Der Benutzer wurde erfolgreich aktiviert.'
      end
# Ausbilder deaktiviert Auszubildenden
    elsif current_user.role.check?
      if current_user.id == @user.instructor_id
          @user.deleted = true
          @user.save!
          redirect_to users_path, :notice => 'Der Auszubildende wurde erfolgreich deaktiviert.'
      else redirect_to welcome_path  
      end
    else redirect_to welcome_path  
    end
    
   
    
  end  
  private
  
    def correct_user
      @user = User.find(params[:id])
      redirect_to welcome_path unless current_user?(@user)
    end

end
