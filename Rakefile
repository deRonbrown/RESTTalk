require 'rake'
require 'yaml'

ENV['RACK_ENV'] = 'development' if ENV['RACK_ENV'].nil?

# DB tasks
namespace :db do
  require 'dm-core'
  require 'dm-types'
  require 'dm-timestamps'
  require 'dm-constraints'
  require 'dm-validations'
  require 'dm-migrations'
  require 'dm-serializer'

  task :load do
    FileList["models/**/*.rb"].each do |model|
      load model
    end
  end
  
  desc "Print all classes that include DataMapper::Resource."
  task :print_dm_resources  do

    Rake::Task["db:load"].invoke
    ::DataMapper::Model.descendants.each do |resource|
      puts resource
    end
  end

  desc 'Perform automigration - will wipe out db'
  task :automigrate do
    Rake::Task["db:load"].invoke
    ::DataMapper.auto_migrate!
  end

  desc 'Perform non destructive automigration'
  task :autoupgrade do
    Rake::Task["db:load"].invoke
    ::DataMapper.auto_upgrade!
  end

  desc 'Seeds with init data'
  task :seed do
    load File.new("db/seeds.rb")
  end

end