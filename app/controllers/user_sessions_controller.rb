class UserSessionsController < ApplicationController
  skip_before_filter :require_login

  def new
  end

  def create
    if login(params[:user][:email], params[:user][:password])
      #TODO route to redirect
      redirect_back_or_to(:root, notice: 'Login successful')
    else
      flash.now[:alert] = 'Login failed'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(:root, notice: 'Logged out!')
  end
end
