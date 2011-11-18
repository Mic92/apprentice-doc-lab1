require 'spec_helper'

describe ReportEntriesController do
  describe "routing" do
    it "routes to #new" do
      get('/reports/1/report_entries/new').should route_to('report_entries#new', :report_id => '1')
    end

    it "routes to #edit" do
      get('/reports/1/report_entries/1/edit').should route_to('report_entries#edit', :report_id => '1', :id => '1')
    end

    it "routes to #create" do
      post('/reports/1/report_entries').should route_to('report_entries#create', :report_id => '1')
    end

    it "routes to #update" do
      put('/reports/1/report_entries/1').should route_to('report_entries#update', :report_id => '1', :id => '1')
    end

    it "routes to #destroy" do
      delete('/reports/1/report_entries/1').should route_to('report_entries#destroy', :report_id => '1', :id => '1')
    end
  end
end
