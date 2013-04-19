module ApplicationHelper
  def server_query(param)
    require 'open-uri'
    param[:user] = cookies[:username]
    param[:pwd] = cookies[:password]
    
    open("%s?%s" % [APP_CONFIG[:service_url], Rack:Utils.build_query(param)]).read
  end

  def freebusy(room, from, to)
    param = {:action=>"freebusy", :room=>room, :from=>from.iso8601, :to=>to.iso8601}
    server_query(param)
  end

  def book(room, starttime, endtime, subject, body)
    param = {:action=>"book", :room=>room, :start=>starttime.iso8601, :end=>endtime.iso8601, :subject=>subject, :body=>""}
    server_query(param)
  end

  def cancel(room, starttime, endtime, subject, body)
    param = {:action=>"cancel", :room=>room, :start=>starttime.iso8601, :end=>endtime.iso8601, :subject=>subject, :body=>""}
    ActiveSupport::JSON.decode(server_query(param))
  end

end
