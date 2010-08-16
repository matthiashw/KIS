class InstallController < ApplicationController
  layout 'login'
  skip_before_filter :login_required
  before_filter :check_install

  def check_install
    return access_denied if already_installed?
  end
  
  def index
    # set vars
    step = "1"
    session[:install_finished] = 0

    # check for step in session
    # this overrides params
    if session[:step]
      step = session[:step]
    end

    # check for step in params
    if params[:step]
      step = params[:step]
    end

    # set language
    if params[:language]
      params[:locale] = params[:language]
    end

    I18n.locale = params[:locale]

    ##########
    # STEP 1 #
    ##########
    if step == "1"

      if params[:lang]
        step = session[:step] = "2"
        session[:lang_finished] = 1
      end

    end

    ##########
    # STEP 2 #
    ##########
    if step == "2"
      if !params.has_key?(:user)
        @user = User.new
      else
        @user = User.new(params[:user])
        @user.attributes = {'domain_ids' => []}.merge(params[:user] || {})

        if @user.save
          flash.now[:notice] = t('messages.users.registration_success')
          step = session[:step] = "3"
          session[:admin_finished] = 1

          if session[:lang_finished] == 1
            session[:install_finished] = 1
          end
        end

        render :action => 'index'
      end

    end

    ##########
    # STEP 3 #
    ##########
    if session[:admin_finished] == 1 && session[:lang_finished] == 1
      session[:install_finished] = 1
    end

    if step == "3"
      if session[:install_finished] == 1
        install_finish
      end
    end

  end

  def install_finish
    if !already_installed?
      sql = ActiveRecord::Base.connection();
      sql.execute "SET autocommit=0";
      sql.begin_db_transaction
      id =	sql.execute("INSERT INTO variables (name,value) VALUES('install','1')");
      sql.commit_db_transaction
    end
  end

end
