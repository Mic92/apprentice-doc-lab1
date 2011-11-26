require 'spec_helper'

describe PasswordsController do
  describe "routing" do
    it "routes to #update" do
      put('/passwords/1').should route_to('passwords#update', :id => '1')
    end
  end
end
