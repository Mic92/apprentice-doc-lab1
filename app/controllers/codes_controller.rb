class CodesController < ApplicationController
  before_filter :authenticate
  before_filter :admin
  
  def index
    @codes = Code.all
    @title = "Code Liste"
    respond_to do |format|
      format.html
    end
  end

  def show
    @code = Code.find(params[:id])
    @title = "Code anzeigen"
    respond_to do |format|
      format.html
    end
  end

  def edit
    @code = Code.find(params[:id])
    @title = "Code bearbeiten"

    respond_to do |format|
      format.html
    end
  end

  def new
    @code = Code.new
    @title = "Code anlegen"

    respond_to do |format|
      format.html
    end
  end

  def create
    @code = Code.new(params[:code])
    
    respond_to do |format|
      if @code.save
        format.html { redirect_to @code, notice: 'Der Code wurde erfolgreich angelegt' }
      else
        format.html { render action: "new" }
      end
    end

  end

  def update
    @code = Code.find(params[:id])

    respond_to do |format|
      if @code.update_attributes(params[:code])
        format.html { redirect_to @code, notice: 'Der Code wurde erfolgreich bearbeitet' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @code = Code.find(params[:id])
    @code.destroy

    respond_to do |format|
      format.html { redirect_to codes_url }
    end
  end
end
