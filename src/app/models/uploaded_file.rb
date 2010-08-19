class UploadedFile < ActiveRecord::Base
  belongs_to :task
  #save file in folder and database
  def self.savefile(upload,taskid)
    begin
      name =  upload['datafile'].original_filename
              upload['datafile']
      directory = "public/taskfiles/" + taskid.to_s
      unless File.exists?(directory)
        Dir.mkdir(directory)
      end
      # create the file path
      path = File.join(directory, name)
      # write the file
      File.open(path, "wb") { |f| f.write(upload['datafile'].read) }

      file = UploadedFile.new(:name => name, :path=> path, :task_id => taskid)
      file.save
      return true
    rescue
      return false
    end
  end

end
