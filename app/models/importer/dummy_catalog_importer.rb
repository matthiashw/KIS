class Importer::DummyCatalogImporter
   def import catalog
      root_node=Node.new( :name => "Dummy Root Node")
      root_node.save!
      catalog.root_node=root_node
      catalog.save!
  end
end
