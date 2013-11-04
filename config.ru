$:.unshift File.expand_path("./../lib", __FILE__)

require 'bundler'
Bundler.require

require 'app'
require 'api'

ENV['RACK_ENV'] ||= 'development'

use ActiveRecord::ConnectionAdapters::ConnectionManagement
run LandLordApp

map '/api/v1/' do
  run LandLordAPI
end
