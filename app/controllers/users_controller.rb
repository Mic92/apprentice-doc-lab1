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

# UsersController ist verantwortlich für die Benutzerverwaltung. Je nach
# Rechtevergabe für den Benutzer sind verschiedene Funktionalitäten zu
# berücksichtigen.
# Die Funktionalität besteht nur für angemeldete Benutzer.
class UsersController < ApplicationController
  
  before_filter :authenticate
  before_filter :correct_user, :only => [ :show, :edit, :update]
  
  # Die Methode 'index' zeigt einem Administrator alle Benutzer an, Ausbilder werden ihre Auszubildenden angezeigt.
  # Für Auszubildende hat die Methode keine Verwendung und ist gesperrt.
   def index
    setupPager(User, params)
    #if current_user.role.admin?
    #  @users = pager(User).search(params[:search])
    #elsif current_user.role.modify?
    #  @users = current_user.apprentices.search(params[:search])
    #else redirect_to welcome_path
    #end

    @users = User.all
    respond_to do |format|
      format.html
      format.json { render json: @users }
    end

  end
  # Die Methode 'show' zeigt das eigene Profil an.

  def show
    
    @user = User.find(params[:id])
    
    #if current_user.role.admin? && current_user != User.find(params[:id])
    #  @user = User.find(params[:id])
    #  @role = Role.find(@user.role_id)
    #else
    #  @user = current_user
    #end

    respond_to do |format|
      format.html # show.html.erb
     # format.json { render json: @user }
      format.json { render json: @user, except: [:hashed_password, :salt, :deleted,
      	:pw_expired_at, :pw_recovery_hash, :role_id, :template_id]}
    end
  end

  # Die Methode 'new' erzeugt einen neuen Nutzer, wenn man Administrator oder Ausbilder ist. Für Auszubildene ist die Methode gesperrt.

  def new
    @templates = Template.all
    if current_user.role.admin?
      @user = User.new
      @roles = Role.all
    elsif current_user.role.modify?
      @user = User.new
      @roles = Role.where(:admin => false, :modify => false, :check => false)
    else
      redirect_to welcome_path
    end
  end

  # Die Methode 'edit' ermöglicht das Editieren des eigenen Profils.

  def edit
    @user = User.find(params[:id])
    @templates = Template.all
    @template = @user.template_id
    @roles = Role.all
    @role = @user.role_id
  end

  # Die Methode 'create' erstellt einen neuen Benutzer, sofern dieser über valide Attribute verfügt.
  # Administratoren dürfen jede Art von Benutzer erstellen, Ausbilder nur Auszubildende, Auszubildenden ist die Methode gesperrt.

  def create
    # roles/templates muss initialisiert werden für collection_select, falls save fehlschlägt.
    @templates = Template.all
    if current_user.role.admin?
      @roles = Role.all
    elsif current_user.role.modify?
      @roles = Role.where(:admin => false, :modify => false, :check => false)
    end

    # zufälliges password wird generiert

    if params[:user] != nil
      @password = PasswordsController.random_password
      params[:user][:password] = @password
      params[:user][:password_confirmation] = @password
      params[:user][:pw_expired_at] = Time.now.utc
      params[:user][:pw_recovery_hash] = '/welcome'
    end

    @user = User.new(params[:user])
    if @user == nil
      render 'new'
    elsif current_user.role.admin?

      if @user.save
        UserMailer.welcome_mail(@user, @password).deliver
        redirect_to users_path, :notice => 'Der Benutzer wurde erfolgreich erstellt.'
      else
        render 'new'
      end

    elsif current_user.role.modify?
      if @user.role_id == nil
        @user.errors.add(:role, "muss ausgewählt werden")
        render 'new'
      else
        @role = Role.find(@user.role_id)
        if @role.admin? || @role.modify?
          render 'new'
        else
          @user = current_user.apprentices.build(params[:user])
          if @user.save
            UserMailer.welcome_mail(@user, @password).deliver
            redirect_to users_path, :notice => 'Der Benutzer wurde erfolgreich erstellt.'
          else
            render 'new'
          end
        end
      end
    else redirect_to welcome_path
    end

  end

  # Die Methode 'update' aktualisiert das eigene Benutzerprofil mit validen Daten.

  def update
    @roles = Role.all
    @templates = Template.all
    if current_user.role.admin?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    if params[:user] != nil
      @attr = params[:user]
      if @attr == nil || (params[:user][:password] != params[:user][:password_confirmation] && params[:user][:password].length < 8)
        @user.update_attributes(@user.attributes.merge(@attr))
        render 'edit'
      else
        if params[:user][:role_id] == nil || (@user == current_user && !current_user.role.admin?)
          @role = Role.find(current_user.role_id)
        else
          @role = Role.find(params[:user][:role_id])
        end
        @attr = params[:user].merge(:role_id => @role.id)
        if current_user.role.admin?
          if current_user.role_id != params[:user][:role_id].to_i && @user.role.admin? && !adminremovable?
            flash.now[:error] = "Das Rechte-Profil kann nicht geändert werden. Mindestens ein Administrator im System ist erforderlich."
            render 'edit'
          else
            if @user.update_attributes(@user.attributes.merge(@attr))
              redirect_to user_path(@user), :notice => 'Das Profil wurde erfolgreich bearbeitet.'
            else
              render 'edit'
            end
          end
        elsif (@role.modify? && !current_user.role.modify? )|| @role.admin?
          render 'edit'
        elsif @user.update_attributes(@user.attributes.merge(@attr))
          redirect_to user_path(@user), :notice => 'Das Profil wurde erfolgreich bearbeitet.'
        else
          render 'edit'
        end
      end
    else
      render 'edit'
    end
  end

  # Die Methode 'destroy' de-/aktiviert einen Benutzer. Administratoren können jeden Benutzer de-/aktivieren.
  # Ausbilder können sich und ihre Auszubildenden deaktivieren, Auszubildende nur sich selbst deaktivieren.

  def destroy

    # Eigenen Account deaktivieren
    @user = User.find(params[:id])
    if current_user == @user
      if @user.role.admin? && !adminremovable?
        redirect_to users_path, :notice => 'Benutzer konnte nicht deaktiviert werden. Mindestens ein Administrator im System ist erforderlich.'
      else
        @user.deleted = true
        @user.save!
        redirect_to root_path, :notice => 'Ihr Account wurde erfolgreich deaktiviert.'
        sign_out
      end
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
    elsif current_user.role.modify?
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
    if !current_user.role.admin?
      redirect_to welcome_path unless current_user?(@user)
    end
  end

end
