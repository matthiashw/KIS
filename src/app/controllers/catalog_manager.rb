# To change this template, choose Tools | Templates
# and open the template in the editor.

class CatalogManager
  include Singleton
  def initialize
    file=File.join(RAILS_ROOT, 'config','catalog', 'catalog_application.yml')
    file=File.open(file)
    @applications=YAML::load(file)
    
  end

  def application_names
    names=Hash.new
    @applications.each do |k,v|
       names[v['name']] = k
    end
    names
  end

  #Use This for all catalogs except Templates
  def catalog application
    type=CatalogType.find :first , :conditions => { :application => application}
    type.active_catalog
    
  end

  #Use This for Templates
  def template_catalogs
     types=CatalogType.find :all , :conditions => { :application => 'template'}
     active_catalogs=Array.new
     types.each { |type|
       if type.active_catalog
       active_catalogs.push(type.active_catalog)
       end
     }
    types=CatalogType.find :all , :conditions => { :application => 'user_defined'}

     types.each { |type|
       if type.active_catalog
       active_catalogs.push(type.active_catalog)
       end
     }
     active_catalogs

  end

  def applications 
     @applications
  end
end
