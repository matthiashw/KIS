# To change this template, choose Tools | Templates
# and open the template in the editor.

class ImporterManager
  include Singleton

  def initialize
    @import_methods = Hash.new
    @entry_types = Hash.new
    @importer_names_selection = Hash.new
    @importer_names = Hash.new
    file=File.join(RAILS_ROOT, 'config','catalog', 'import.yml')
    file=File.open(file)
    imports=YAML::load(file)
    imports.each_pair do |key, value|
      begin
        @import_methods[key]=value['importer_classname'].constantize.new
        @entry_types[key]=value['entry_classname']
        @importer_names_selection[value['importer_name']]=key
        @importer_names[key]=value['importer_name']
      rescue
       
      end
    end

  end

  def add importer
    @import_methods.merge!(importer)
  end

  
  def import_methods
    @import_methods
  end

  def entry_types
    @entry_types
  end

  def importer_names
    @importer_names
  end

  def importer_names_selection
    @importer_names
  end

end
