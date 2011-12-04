# encoding: utf-8
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  def test_sign_in(user)
    controller.sign_in(user)
  end

  def valid_attributes_business
    {
      :name => 'Mustermann GmbH',
      :zipcode => '12345',
      :city => 'Entenhausen',
      :street => 'Musterstraße'
    }
  end

  def valid_attributes_entry
    {
      :date => '2011-10-02 08:00:00',
      :duration_in_hours => 1.5,
      :text => 'Entry created.'
    }
  end

  def valid_attributes_report
    {
      :period_start => '2011-10-01',
      :period_end => '2011-10-31'
    }
  end

  def valid_attributes_role
    {
      :name => 'Tester',
      :level => 11,
      :read => true,
      :commit => false,
      :export => true,
      :check => true,
      :modify => true,
      :admin => false
    }
  end
  
  def valid_attributes_role_admin
    {
      :name => 'Administrator',
      :level => 1,
      :read => false,
      :commit => false,
      :export => false,
      :check => false,
      :modify => true,
      :admin => true,
    }
  end
  
  def valid_attributes_role_ausbilder
    {
      :name => 'Ausbilder',
      :level => 2,
      :read => true,
      :commit => false,
      :export => true,
      :check => true,
      :modify => true,
      :admin => false
     }
  end
  
  def valid_attributes_role_azubi
    {
      :name => 'Auszubildender',
      :level => 3,
      :read => true,
      :commit => true,
      :export => true,
      :check => false,
      :modify => false,
      :admin => false
    }
  end
      
  def valid_attributes_user
    {
      :name => 'Mustermann',
      :forename => 'Max',
      :zipcode => '01234',
      :street => 'Musterstraße',
      :city => 'Musterstadt',
      :email => 'max@mustermann.de',
	  :salt => '1700b3ac65a142efb7af2db02a1d4c403b1ea1fd854baedc8fb29626347871fd',
	  :hashed_password => '7ebdd167b29f4ae742ab7b18995b2c14a9c5f96f3ede1988e4531451cfc54658', 
      :password => 'unknackbarespasswort',
      :password_confirmation => 'unknackbarespasswort',
      :role_id => 1,
      :template_id => 1
    }
  end

  def valid_attributes_code
    {
      :name => 'Testcode',
      :codegroup => 3,
      :code => 'Das ist langer Code......'
    }
  end

  def valid_attributes_job
    {
      :name => 'Das ist ein Name'
    }
  end

  def valid_attributes_ihk
    {
      :name => 'Das ist ein Name'
    }
  end

  def valid_attributes_template
    {
      :name => 'Das ist ein Name',
      :code_id => 1,
      :job_id => 2,
      :ihk_id => 3
    }
  end

  def valid_attributes_status
    {
      :report => 1,
      :stype => Status.personal,
      #:comment => 'Das ist ein Kommentar eines Ausbilders zum Report in :report'
    }
  end
end
