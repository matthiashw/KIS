# To change this template, choose Tools | Templates
# and open the template in the editor.

class ImporterManager
  include Singleton

  def initialize
    @import_methods = Hash.new
    @entry_types = Hash.new
    file=File.join(RAILS_ROOT, 'config','catalog', 'import.yml')
    file=File.open(file)
    imports=YAML::load(file)
    imports.each_pair do |key, value|
      begin
        @import_methods[key]=value['importer_classname'].constantize.new
        @entry_types[key]=value['entry_classname']
      rescue
       
      end
    end

  end

  def add importer
    @import_methods.merge!(importer)
  end

  public
  def import_methods
    @import_methods
  end

  def entry_types
    @entry_types
  end

end
