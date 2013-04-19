class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :is_login
  #around_filter :set_timezone

  def set_timezone
    Time.use_zone('Beijing') do
      yield
    end
  end


  def is_login
    unless cookies[:username] && cookies[:password] 
      redirect_to login_path + "?redirect=%s" % request.fullpath
    end
  end

  def server_query(param)
    require 'open-uri'
    param[:user] = cookies[:username]
    param[:pwd] = cookies[:password]
    param[:room] = param[:room] + "@ef.com"
    
    log = Logger.new(STDOUT)
    begin
      url = "%s?%s" % [APP_CONFIG[:service_url], Rack::Utils.build_query(param)]
      log.info(url)
      ActiveSupport::JSON.decode(open(url).read)
    rescue
    end
  end

  def freebusy(room, from, to)
    param = {:action=>"freebusy", :room=>room, :from=>from.iso8601, :to=>to.iso8601}
    server_query(param)
  end

  def book(room, starttime, endtime, subject, body)
    param = {:action=>"book", :room=>room, :start=>starttime.iso8601, :end=>endtime.iso8601, :subject=>subject, :body=>body}
    server_query(param)
  end

  def cancel(room, starttime, endtime, subject, body)
    param = {:action=>"cancel", :room=>room, :start=>starttime.iso8601, :end=>endtime.iso8601, :subject=>subject, :body=>""}
    server_query(param)
  end
end
