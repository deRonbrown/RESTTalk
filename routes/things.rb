class RESTTalk < Sinatra::Application
  
  get '/things/?' do
    
    query_params = {}
        
    # Validate params
    params.each { |key, value|
      
      if (Thing.properties.named?(key))
        query_params[key.to_sym] = value
      else
        @talkResponse.add_error :type => "Invalid_Parameter", :message => "Parameter '#{key}' is invalid"
      end
    }
    
    puts query_params
    
    things = Thing.all(query_params)
    
    if not @talkResponse.is_error?
      @talkResponse.result = things.as_json().map{|jsonObj| jsonObj.reject{|k,v| v.nil?}}
    end
    
    @talkResponse.to_response
  end
  
  get '/thing/:id/?' do
    
    thing = Thing.get(params[:id])
    if thing.nil?
      @talkResponse.add_error :type => "Not_Found", :message => "No Thing found with id = #{params[:id]}"
    end
    
    if not @talkResponse.is_error?
      @talkResponse.result = [thing.as_json].map{|jsonObj| jsonObj.reject{|k,v| v.nil?}}
    end
    
    @talkResponse.to_response
  end
  
  
end