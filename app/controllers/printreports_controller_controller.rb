class PrintreportsControllerController < ApplicationController
  before_filter :authenticate
  before_filter :read
  before_filter :export
    
  def show
    @report = Report.find(params[:id])
    @title = "Druckbare Reportansicht"
    @code = @report.user.template.code

    respond_to do |format|
      format.html
    end
  end

end
