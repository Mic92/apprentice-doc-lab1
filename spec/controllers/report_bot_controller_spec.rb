require 'spec_helper'

describe ReportBotController do

  describe "GET 'unwritten'" do
    it "returns http success" do
      get 'unwritten'
      response.should be_success
    end
  end

  describe "GET 'unchecked'" do
    it "returns http success" do
      get 'unchecked'
      response.should be_success
    end
  end

end
