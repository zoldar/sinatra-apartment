$:.unshift File.expand_path("./../lib", __FILE__)

namespace :db do
  desc "migrate your database"
  task :migrate do
    require 'bundler'
    Bundler.require
    require_relative 'lib/db/connection'
    DB::Connection.establish
    ActiveRecord::Migrator.migrate('lib/db/migrate')
  end
end
