class RolesController < ApplicationController
  
  before_filter :authenticate
  
  def new
    @role = Role.new
  end

  def edit
    @role = Role.find(params[:id])
  end

  def create
    @role = Role.new(params[:id])
    
      if @role.save
        redirect_to welcome_path, :notice => "Das Rechte-Profil #{@role.name} wurde erfolgreich erstellt."
      else
        render 'new' 
      end
  end

  def update
    @role = Role.find(params[:id])
    
    if params[:role] != nil && @role.update_attributes(params[:role])
      redirect_to welcome_path, :notice => "Das Rechte-Profil #{@role.name} wurde erfolgreich bearbeitet."
    else  
      render 'edit'
    end
  end

  def destroy
  
  end

end
