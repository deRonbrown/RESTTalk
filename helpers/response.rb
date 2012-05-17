class TalkResponse < Object

  attr_accessor :url , :status, :status_code, :result, :callback, :numResults, :resultsPerQuery
  def initialize url, callback = nil, status=:ok, result={}, numResults=0, resultsPerQuery=0
    @url = url
    @status = status
    @callback = callback
    @status_code = 200
    @numResults = numResults
    @resultsPerQuery = resultsPerQuery
    @result = result
    @errors = []
  end

  def is_jsonp?
    not @callback.nil?
  end

  def add_error hash
    @status = :err
    @errors.push hash
  end

  def to_response
    if @callback
      "#{@callback}(#{@result.to_json})"
    else
      to_json
    end
  end
  

  def to_json(*a)
    hash = {"url" => @url, "status"=>@status.to_s, "resultsPerQuery"=>@resultsPerQuery, "numResults"=>@numResults} 
    if @status == :ok
      hash["result"] = @result
    else
      hash["errors"] = @errors
    end
    hash.to_json(*a)
  end
  
  def is_error?()
    !@errors.empty?
  end

end
