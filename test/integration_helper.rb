ENV['RACK_ENV'] = 'test'
require 'bundler'
Bundler.require
require './test/test_helper'

require 'apartment_system'
