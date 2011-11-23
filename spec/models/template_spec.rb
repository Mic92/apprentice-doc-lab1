require 'spec_helper'

describe Template do 
  describe "Template associations" do
    before(:each) do
      @job = Job.create valid_attributes_job
      @code = Code.create valid_attributes_code
      @ihk = Ihk.create valid_attributes_ihk
      @template = Template.new valid_attributes_template
      @template.job_id = @job.id
      @template.ihk_id = @ihk.id
      @template.code_id = @code.id
      @template.save
    end
 
    it "should create a new instance with given valid attributes" do
      Template.create! (valid_attributes_template)
    end
 
    it 'should have a job attribute' do
      @template.should respond_to(:job)
    end

    it 'should have a ihk attribute' do
      @template.should respond_to(:ihk)
    end
    
    it 'should have a code attribute' do
      @template.should respond_to(:code)
    end

    it "should have the right associated job" do
      @template.job.should eq(@job)
    end

    it "should have the right associated ihk" do
      @template.ihk.should eq(@ihk)
    end

    it "should have the right associated code" do
      @template.code.should eq(@code)
    end

    it "should not destroy associated job" do
      @template.destroy
      Job.find_by_id(@job.id).should_not be_nil
    end
    
    it "should not destroy associated ihk" do
      @template.destroy
      Ihk.find_by_id(@ihk.id).should_not be_nil
    end
    
    it "should not destroy associated code" do
      @template.destroy
      Code.find_by_id(@code.id).should_not be_nil
    end

  end

  describe "validations" do

    before(:each) do
      @attributes = valid_attributes_template
    end

    it "should require attribute name" do
      @attributes.delete(:name)
      Template.new(@attributes).should_not be_valid
    end

    it "should require attribute code_id" do
      @attributes.delete(:code_id)
      Template.new(@attributes).should_not be_valid
    end
    
    it "should require attribute job_id" do
      @attributes.delete(:job_id)
      Template.new(@attributes).should_not be_valid
    end
    
    it "should require attribute ihk_id" do
      @attributes.delete(:ihk_id)
      Template.new(@attributes).should_not be_valid
    end
  end
end
