class DatabaseBackupController < ApplicationController
  def export
  end


  def import
  end


  def exportFile
    # create the file path
    path = "#{RAILS_ROOT}/db/data.yml"
    begin
      # dump db to db/data.yml
      YamlDb::dump(path)
    rescue
      flash.now[:error] = t('database_backup.export.failure')
      format.html {render :action => "export"}
      format.xml {render :status => :unprocessable_entity}
    else
      if File.exist?(path)
        respond_to do |format|
          flash.now[:notice] = t('database_backup.export.success')
          format.html {render :action => "export"}
          format.xml {render :status => :success}
        end
        send_file path
      else
        respond_to do |format|
          flash.now[:error] = t('database_backup.export.failure')
          format.html {render :action => "export"}
          format.xml {render :status => :unprocessable_entity}
        end
      end
    end
  end

  
  def importFile
    upload = params[:post]
    if !upload
      respond_to do |format|
        flash.now[:error] = t('database_backup.import.noFile')
        format.html {render :action => "import"}
        format.xml {render :status => :unprocessable_entity}
      end
    else
      # create the file path
      path = "#{RAILS_ROOT}/db/data.yml"

      # write the file
      File.open(path, "wb") { |f| f.write(upload['attached'].read)}

      begin
        # load db from file
        YamlDb::load(path)
      rescue
        respond_to do |format|
          flash.now[:error] = t('database_backup.import.failure')
          format.html {render :action => "import"}
          format.xml {render :status => :unprocessable_entity}
        end
      else
        respond_to do |format|
          flash.now[:notice] = t('database_backup.import.success')
          format.html {render :action => "import"}
          format.xml {render :status => :success}
        end
      end
    end
  end
end
