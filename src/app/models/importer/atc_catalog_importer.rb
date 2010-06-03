# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'spreadsheet'

class Importer::AtcCatalogImporter
   def import catalog,file

      root_node=catalog.create_root_node
      catalog.save
  end
end
