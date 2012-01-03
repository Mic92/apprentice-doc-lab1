class TemplatesController < ApplicationController
  before_filter :authenticate
  before_filter :admin

  def index
    setupPager(Template, params)
    @templates = pager(Template).all
    @title = "Vorlagenliste"

    respond_to do |format|
      format.html
    end
  end

  def show
    @template = Template.find(params[:id])
    @title = "Vorlage anzeigen"

    respond_to do |format|
      format.html
    end
  end

  def fetchJobIhkCode
    @jobs = Job.all
    @ihks = Ihk.all
    @codes = Code.all
  end

  def edit
    @template = Template.find(params[:id])
    @title = "Vorlage bearbeiten"
    fetchJobIhkCode

    respond_to do |format|
      format.html
    end
  end

  def new
    @template = Template.new
    @title = "Vorlage anlegen"
    fetchJobIhkCode

    respond_to do |format|
      format.html
    end
  end

  def create
    fetchJobIhkCode
    @template = Template.new(params[:template])
    
    respond_to do |format|
      if @template.save
        format.html { redirect_to @template, notice: 'Das Template wurde erfolgreich angelegt' }
      else
        format.html { render action: "new" }
      end
    end

  end

  def update
    fetchJobIhkCode
    @template = Template.find(params[:id])

    respond_to do |format|
      if @template.update_attributes(params[:template])
        format.html { redirect_to @template, notice: 'Das Template wurde erfolgreich bearbeitet' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @template = Template.find(params[:id])
    @template.destroy

    respond_to do |format|
      format.html { redirect_to templates_url }
    end
  end
end
