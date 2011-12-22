class JobsController < ApplicationController
  before_filter :authenticate
  before_filter :admin

  def index
    search = params[:search]
    if search.nil?
      @jobs = Job.order('name').all
    else
      @jobs = Job.where(['name LIKE ?', "%#{search}%"]).order('name')
    end
    @title = "Job Liste"
    respond_to do |format|
      format.html
    end
  end

  def show
    @job = Job.find(params[:id])
    @title = "Job anzeigen"
    respond_to do |format|
      format.html
    end
  end

  def edit
    @job = Job.find(params[:id])
    @title = "Job bearbeiten"

    respond_to do |format|
      format.html
    end
  end

  def new
    @job = Job.new
    @title = "Job anlegen"

    respond_to do |format|
      format.html
    end
  end

  def create
    @job = Job.new(params[:job])
    
    respond_to do |format|
      if @job.save
        format.html { redirect_to @job, notice: 'Der Job wurde erfolgreich angelegt' }
      else
        format.html { render action: "new" }
      end
    end

  end

  def update
    @job = Job.find(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to @job, notice: 'Der Job wurde erfolgreich bearbeitet' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to jobs_url }
    end
  end
end
