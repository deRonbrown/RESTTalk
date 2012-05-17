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
  
  get '/thing/:id/items/?' do
    
    query_string = "thing_id=#{params[:id]}&"
    
    # remove splat, captures, and id params
    @removeSPI.each {|n| params.delete(n)}

    # build rest of query string
    params.each {|key, value| query_string += "#{key}=#{value}&"}
    
    call env.merge("PATH_INFO" => "/items", "QUERY_STRING" => query_string)
  end
  
  post '/things/?' do
    puts params
    [:id].each { |k| params.delete(k) }
    post_or_put(params)
  end
  
  put '/thing/:id/?' do
    puts params
    ["splat", "captures"].each{ |k| params.delete(k) }
    post_or_put(params)
  end
  
  def post_or_put(params)
    
    query_params = {}
    
    params.each { |key, value|
      
      if (Thing.properties.named?(key))
        
        # Validate integer values
        if (Thing.properties[key].class == DataMapper::Property::Integer)
          begin
            Integer(value)
          rescue ArgumentError
            @talkResponse.add_error :type => "Invalid_Type", :message => "Value of '#{key}' must be an integer type"
          end
        end
        
        # Validate DateTime values
        if (Thing.properties[key].class == DataMapper::Property::DateTime)
          begin
            DateTime.iso8601(value).new_offset(0)
          rescue ArgumentError
            @talkResponse.add_error :type => "Invalid_Time", :message => "Value '#{value}' is an invalid ISO 8601 string"
          end
        end
                
        query_params[key.to_sym] = value
      else
        @talkResponse.add_error :type => "Invalid_Parameter", :message => "Parameter '#{key}' is invalid"
      end
    }
    
    thing = nil
    
    if not @talkResponse.is_error?
      
      # id to update (PUT request)
      if not query_params[:id].nil?
        
        thing = Thing.get(query_params[:id])
        if thing.nil?
          @talkResponse.add_error :type => "Not_Found", :message => "No Thing found with id = #{query_params[:id]}"
        else
          Thing.transaction do
            if (!thing.destroy() || !(thing = Thing.new(query_params)).save)
              @talkResponse.add_error :type => "Transaction_Failed", :message=>"Transaction for thing id #{query_params[:id]} failed"
            end
          end
        end
      
      # create new Thing (POST request)  
      else
        thing = Thing.new(query_params)
        if not thing.save
          @talkResponse.add_error :type => "Save_Failed", :message => "Thing failed to save"
        end
      end
      
    end
    
    if not @talkResponse.is_error?
      @talkResponse.result = [thing.as_json].map{|jsonObj| jsonObj.reject{|k,v| v.nil?}}
    end
    
    @talkResponse.to_response
  end
  
  delete '/thing/:id/?' do
    
    thing = Thing.get(params[:id])
    if thing.nil?
      @talkResponse.add_error :type => "Not_Found", :message => "No Thing found with id = #{params[:id]}"
    end
    
    if not @talkResponse.is_error?
      @talkResponse.result = [thing.as_json()].map{|jsonObj| jsonObj.reject{|k,v| v.nil?}}
      
      items = Item.all(:thing_id => thing.id)
      
      if not thing.destroy!
        @talkResponse.add_error :type => "Delete_Failed", :message => "Thing with id = #{thing.id} failed to delete"
      else
        
        # remove thing reference
        items.each { |i|
          i.thing_id = nil
          i.save
        }
        
      end
    end
    
    @talkResponse.to_response
  end
  
end