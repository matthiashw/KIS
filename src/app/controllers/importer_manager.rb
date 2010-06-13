# To change this template, choose Tools | Templates
# and open the template in the editor.

class ImporterManager
  include Singleton

  def initialize

    @import_methods = {
        "Loinc Catalog Importer" => Importer::LoincCatalogImporter.new,
        "Ucum Most Common Units Importer" => Importer::UcumCatalogImporter.new
         }
  end

  def add importer
    @import_methods.merge!(importer)
  end

  public
  def import_methods
    @import_methods
  end

end
