$:.unshift File.expand_path("./../lib", __FILE__)

require 'bundler'
Bundler.require

require 'app'

ENV['RACK_ENV'] ||= 'development'

use ActiveRecord::ConnectionAdapters::ConnectionManagement
run ApartmentApp
