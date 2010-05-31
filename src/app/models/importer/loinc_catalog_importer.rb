# To change this template, choose Tools | Templates
# and open the template in the editor.

class Importer::LoincCatalogImporter 
  def import catalog,file
      303.times { file.readline  }
      csv=CSV.new(file,:col_sep => "\t",:headers => "true")
      root_node=catalog.create_root_node
      catalog.save
  end
end
