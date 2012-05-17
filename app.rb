require 'sinatra'
require 'json'
require 'active_support/core_ext/date_time/calculations'

class RESTTalk < Sinatra::Application
  #WAF is going to take care of most of these things for us
  disable :protection
  
  # set defaults here
  configure :production do
  
  end

  configure :development do

  end

end

require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'routes/init'