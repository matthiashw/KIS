class UploadedFile < ActiveRecord::Base
  belongs_to :task
  #save file in folder and database
  def self.savefile(upload,taskid,filecomment)
    begin
      name =  upload['datafile'].original_filename
              upload['datafile']

      taskfilesdir = "/taskfiles/"
      directory = "public" + taskfilesdir
      unless File.exists?(directory)
        Dir.mkdir(directory)
      end
      
      directory += taskid.to_s
      unless File.exists?(directory)
        Dir.mkdir(directory)
      end
      # create the file path
      taskfilesdir += taskid.to_s
      path = File.join(directory, name)
      dbpath = File.join(taskfilesdir, name)
      # write the file
      File.open(path, "wb") { |f| f.write(upload['datafile'].read) }

      file = UploadedFile.new(:name => name, :path=> dbpath, :task_id => taskid ,:description => filecomment)
      file.save
      return true
    rescue
      return false
    end
  end

  def self.deletefile(del)
    begin
      file = UploadedFile.find(del.keys[0])
      File.delete("#{RAILS_ROOT}/public#{file.path}") if File.exist?("#{RAILS_ROOT}/public#{file.path}")
      file.destroy
      return true
    rescue
      return false
    end
  end

end
