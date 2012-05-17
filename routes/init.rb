class RESTTalk < Sinatra::Application

  before do
    content_type :json

    # Response object
    @talkResponse = TalkResponse.new request.path
    
    # Return object limit
    @numLimit = 100
    @talkResponse.resultsPerQuery = @numLimit
    
    # Params added by :id to be ignored
    @removeSPI = ["splat", "captures", "id"]
        
  end


end

require_relative 'main'