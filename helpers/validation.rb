helpers do

  def unix_time? time
    begin
      Integer(time) > 0 ? true : false
    rescue ArgumentError
      false
    end
  end

end