class LoginController < ApplicationController
  skip_filter :is_login
  def new
    respond_to do |format|
      format.html
    end
  end

  def today
    redirect_to freebusy_path(:date=>DateTime.now.midnight.iso8601, :room=>params[:room])
  end

  def create
    username = params[:username]
    password = params[:password]
    if username && password
      expires = 2.week.from_now
      cookies[:username] = {:value=>username, :expires=>expires}
      cookies[:password] = {:value=>password, :expires=>expires}
      flash[:notice] = "Logged in"
      
      redirect_to params[:redirect]
    end
  end

  def destory
    cookies.delete :username
    cookies.delete :password
    redirect_to login_path
  end

end
