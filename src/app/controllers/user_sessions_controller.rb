class UserSessionsController < ApplicationController
  layout 'login'
  skip_before_filter :login_required
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      I18n.locale = current_user.language
      flash.now[:notice] = t('messages.user_session.logged_in')
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash.now[:notice] = t('messages.user_session.logged_in')
    redirect_to root_url
  end
end
