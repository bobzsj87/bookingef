class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :is_login


  def is_login
    unless cookies[:username] && cookies[:password] 
      redirect_to login_path
    end
  end
end
