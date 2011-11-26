require 'spec_helper'

describe ApprenticeshipsController do
  describe "routing" do
    it "routes to #create" do
      post('/apprenticeships').should route_to('apprenticeships#create')
    end

    it "routes to #destroy" do
      delete('/apprenticeships/1').should route_to('apprenticeships#destroy', :id => '1')
    end
  end
end
