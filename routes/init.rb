class RESTTalk < Sinatra::Application

  before do
    content_type :json

    # Response object
    @talkResponse = TalkResponse.new request.path
        
    # Params added by :id to be ignored
    @removeSPI = ["splat", "captures", "id"]
        
  end


end

require_relative 'main'
require_relative 'things'
require_relative 'items'