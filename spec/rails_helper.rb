# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'solid_queue_pat_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../dummy/config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'solid_queue'
require 'solid_queue_pat/processes'

ActiveRecord::Migration.maintain_test_schema!
