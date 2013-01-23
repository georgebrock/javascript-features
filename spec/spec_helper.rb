# -*- encoding : utf-8 -*-
ENV["RAILS_ENV"] ||= 'test'
require_relative './dummy/config/environment'
RSpec.configure do |config|
  config.order = "random"
end
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
Capybara.default_driver = :poltergeist
