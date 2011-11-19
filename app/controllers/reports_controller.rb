# encoding: utf-8
class ReportsController < ApplicationController
  def index
    @reports = Report.all
  end

  def show
    @report = Report.find(params[:id])
    @entries = @report.report_entries
  end

  def new
    @report = Report.new
  end

  def edit
    @report = Report.find(params[:id])
  end

  def create
    @report = current_user.reports.build(params[:report])

    if @report.save
      redirect_to reports_path, :notice => 'Bericht wurde erfolgreich erstellt.'
    else
      render 'new'
    end
  end

  def update
    @report = Report.find(params[:id])

    if params[:report] != nil && @report.update_attributes(params[:report])
      redirect_to reports_path, :notice => 'Bericht wurde erfolgreich bearbeitet.'
    else
      render 'edit'
    end
  end

  def destroy
    @report = Report.find(params[:id])
    @report.destroy

    redirect_to reports_path, :notice => 'Bericht wurde erfolgreich gelöscht.'
  end
end
