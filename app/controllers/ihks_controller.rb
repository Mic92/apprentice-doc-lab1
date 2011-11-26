class IhksController < ApplicationController
  before_filter :authenticate
  before_filter :admin

  def index
    @ihks = Ihk.all
    @title = "IHK Liste"

    respond_to do |format|
      format.html
    end
  end

  def show
    @ihk = Ihk.find(params[:id])
    @title = "IHK anzeigen"
    respond_to do |format|
      format.html
    end
  end

  def edit
    @ihk = Ihk.find(params[:id])
    @title = "IHK bearbeiten"

    respond_to do |format|
      format.html
    end
  end

  def new
    @ihk = Ihk.new
    @title = "IHK anlegen"
    respond_to do |format|
      format.html
    end
  end

  def create
    @ihk = Ihk.new(params[:ihk])
    
    respond_to do |format|
      if @ihk.save
        format.html { redirect_to @ihk, notice: 'Die IHK wurde erfolgreich angelegt' }
      else
        format.html { render action: "new" }
      end
    end

  end

  def update
    @ihk = Ihk.find(params[:id])

    respond_to do |format|
      if @ihk.update_attributes(params[:ihk])
        format.html { redirect_to @ihk, notice: 'Die IHK wurde erfolgreich bearbeitet' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @ihk = Ihk.find(params[:id])
    @ihk.destroy

    respond_to do |format|
      format.html { redirect_to ihks_url }
    end
  end
end
