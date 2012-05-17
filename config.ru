root = ::File.dirname(__FILE__)
require ::File.join(root, "app")
set :env, (ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :development)
if :env == :production
  require 'rubygems'
  Gem.clear_paths
  ENV['GEM_HOME'] = ::File.join(root,"vendor/bundle")
  ENV['GEM_PATH'] =  ENV['GEM_HOME']+":/var/lib/gems/1.9.1"
end

run RESTTalk.new
