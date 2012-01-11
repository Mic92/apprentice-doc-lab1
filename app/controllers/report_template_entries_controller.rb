class ReportTemplateEntriesController < ApplicationController
  include PrintReportsHelper
  
  before_filter :authenticate
  before_filter :read
#  before_filter :export
  
  before_filter :correct_user, :only => [ :show ]
  
  def correct_user
    @user = Report.find(params[:id]).user
    redirect_to welcome_path unless current_user?(@user) or current_user.role.check?
    redirect_to reports_path, :notice => 'Keine Druckvorlage zugeordnet' unless not @user.template.nil?
  end
  
  def prepare
    @code = @report.user.template.code
    @rawCode = @code.code
  end
  
  def edit
    @report = Report.find(params[:id])
    @title = 'Report Editansicht'
    
    self.prepare
    
    self.editRawCode
  end

  def update
    @report = Report.find(params[:id])

    self.prepare
    
    self.handleSubmittedReport(params)
    # Der Status des Berichts wird durch das Bearbeiten wieder auf personal gesetzt, damit er wieder
    # freigegeben werden kann.
    @report.status.update_attributes(:stype => Status.personal)
    redirect_to report_path(@report)
  end

end
