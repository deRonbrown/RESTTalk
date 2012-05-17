class RESTTalk < Sinatra::Application
  
  get '/items/?' do
    
    query_params = {}
        
    # Validate params
    params.each { |key, value|
      
      if (Item.properties.named?(key))
        query_params[key.to_sym] = value
      else
        @talkResponse.add_error :type => "Invalid_Parameter", :message => "Parameter '#{key}' is invalid"
      end
    }
    
    puts query_params
    
    items = Item.all(query_params)
    
    if not @talkResponse.is_error?
      @talkResponse.result = items.as_json().map{|jsonObj| jsonObj.reject{|k,v| v.nil?}}
    end
    
    @talkResponse.to_response
  end
  
  get '/item/:id/?' do
    
    item = Item.get(params[:id])
    if item.nil?
      @talkResponse.add_error :type => "Not_Found", :message => "No Item found with id = #{params[:id]}"
    end
    
    if not @talkResponse.is_error?
      @talkResponse.result = [item.as_json].map{|jsonObj| jsonObj.reject{|k,v| v.nil?}}
    end
    
    @talkResponse.to_response
  end
  
  
end