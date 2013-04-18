class LoginController < ApplicationController
  def new
    respond_to do |format|
      format.html
    end
  end

  def create
    username = params[:username]
    password = params[:password]
    if username && password
      expires = 2.week.from_now
      cookies[:username] = {:value=>username, :expires=>expires}
      cookies[:password] = {:value=>password, :expires=>expires}
      flash[:notice] = "Logged in"
      
      redirect_to login_path
    end
  end


end
