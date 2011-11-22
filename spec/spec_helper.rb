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
      :name => 'Ausbilder',
      :level => 2,
      :read => false,
      :commit => false,
      :export => true,
      :check => true,
      :modify => true,
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
      :hashed_password => 'abcdefghijklmnopqrstuvwxyz',
      :role_id => 1
    }
  end

  def valid_attributes_code
    {
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
      :job_id => 1,
      :ihk_id => 1
    }
  end

  def valid_attributes_business
    {
      :name => 'Das ist ein Name',
      :zipcode => '12345',
      :street => 'Strasse',
      :city => 'Stadt'
    }
  end
end
