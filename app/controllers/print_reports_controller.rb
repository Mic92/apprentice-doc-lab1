class PrintReportsController < ApplicationController
  include PrintReportsHelper

  before_filter :authenticate
  before_filter :read
  before_filter :export

  before_filter :correct_user, :only => [ :show ]

  def correct_user
    @user = Report.find(params[:id]).user
    redirect_to welcome_path unless current_user?(@user)
  end

  def show
    #TODO hier noch aufpassen, dass der Nutzer den Report auch lesen darf
    @report = Report.find(params[:id])
    @title = 'Report Druckansicht'
    @rawCode = @report.user.template.code.code
    
    self.handleRawCode

    respond_to do |format|
      format.html
    end
  end

end
