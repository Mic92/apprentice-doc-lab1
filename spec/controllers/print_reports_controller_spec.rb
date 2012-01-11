require 'spec_helper'

describe PrintReportsController do
  before(:each) do
    @admin = User.create valid_attributes_user
    @ihk = Ihk.create valid_attributes_ihk
    @code = Code.create valid_attributes_code
    @job = Job.create valid_attributes_job
    @template = Template.create valid_attributes_template.merge(:job_id => @job.id, :ihk_id => @ihk.id, :code_id => @code.id)
    @admin.template = @template
    @role = Role.create valid_attributes_role_admin.merge(:export => true, :read => true)
    @role.users << @admin
    @report = @admin.reports.create valid_attributes_report
    @report.build_status(:stype => Status.accepted)
    @report.save
    @admin.save
  end
  
  describe "method tests for signed in admin" do
    before(:each) do
      test_sign_in(@admin)
    end

    describe "GET 'show'" do
      it "returns http success" do
        get 'show', :id => @report
        response.should be_success
      end
    end
  end
end
