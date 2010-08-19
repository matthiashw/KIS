module InstallHelper
  def current_step
    step = "1"

    if session[:step]
      step = session[:step]
    end

    if params[:step]
      step = params[:step].strip
    end

    step
  end

  def install_finished?
    if session[:install_finished] == 1
      return true
    end

    return false
  end

  def admin_finished?
    if session[:admin_finished] == 1
      return true
    end

    return false
  end
end
