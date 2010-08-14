class AdminController < ApplicationController
  before_filter :check

  def index
    if check_for_errors?(@errors)
      flash[:warning] = t('admin.status.warning')
    end
  end

  def status
    @user = User.new
  end

  def check
    @errors = check_models(models_to_check_for_errors)
  end

  def check_models(models)
    errors = {}
   
    models.each do |modelname|
      mymodel = modelname.constantize
      errors = { modelname => { "error" => mymodel.status,
                                "message" => mymodel.message,
                                "setup" => mymodel.setup } }
    end

    errors
  end

  def check_for_errors?(errors)
    return false if errors.empty?
    
    errors.each do |k, v|
      v.each { |key, val| return true if key == "error" && val == false }
    end

    return false
  end

end
