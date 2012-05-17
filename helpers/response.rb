class TalkResponse < Object

  attr_accessor :url , :status, :status_code, :result
  def initialize url, status=:ok, result={}
    @url = url
    @status = status
    @status_code = 200
    @result = result
    @errors = []
  end

  def add_error hash
    @status = :err
    @errors.push hash
  end

  def to_response
    to_json
  end
  

  def to_json(*a)
    hash = {"url" => @url, "status"=>@status.to_s} 
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