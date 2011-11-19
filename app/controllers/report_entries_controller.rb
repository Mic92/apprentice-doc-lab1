# encoding: utf-8
class ReportEntriesController < ApplicationController
  def new
    @report = Report.find(params[:report_id])
    @entry = @report.report_entries.build
  end

  def edit
    @entry = ReportEntry.find(params[:id])
  end

  def create
    @report = Report.find(params[:report_id])
    @entry = @report.report_entries.build(params[:report_entry])

    if @entry.save
      redirect_to @report, :notice => 'Eintrag wurde erfolgreich erstellt.'
    else
      render 'new'
    end
  end

  def update
    @entry = ReportEntry.find(params[:id])

    if params[:report_entry] != nil && @entry.update_attributes(params[:report_entry])
      redirect_to @entry.report, :notice => 'Eintrag wurde erfolgreich bearbeitet.'
    else
      render 'edit'
    end
  end

  def destroy
    @entry = ReportEntry.find(params[:id])
    @report = @entry.report
    @entry.destroy

    redirect_to @report, :notice => 'Eintrag wurde erfolgreich gelöscht.'
  end
end
