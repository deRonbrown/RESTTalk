require 'data_mapper'
require 'dm-timestamps' # Create

require 'yaml'
dbConfig = YAML.load_file("#{Dir.pwd}/config/database.yml")
env = ENV["RACK_ENV"] || "development"
puts "Using database #{dbConfig[env][:database]}"
DataMapper::Model.raise_on_save_failure = true
DataMapper.setup(:default, dbConfig[env])


# Require relatives
require_relative 'thing'
require_relative 'item'

DataMapper.finalize
