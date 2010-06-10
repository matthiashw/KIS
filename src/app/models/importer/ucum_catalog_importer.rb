# To change this template, choose Tools | Templates
# and open the template in the editor.

class Importer::UcumCatalogImporter
   def import catalog,file

      # Create the Hash for Node Names
      class_name_hash=Hash.new

      # Create CSV Object from File
      csv=CSV.new(file,{:col_sep => "\t",:headers => :first_row })
     
     catalog.transaction do

      # Create the Catalogs Helper Root Node
      root_node=Node.new
      root_node.name=catalog.catalog_type.name + " Root Node"
      catalog.root_node=root_node
      # Iterate over Rows
      while (row=csv.shift)
        #  Get The Values
         class_name =  row['Kind of Quantity']
         name = row['ConceptID']
         code = row['Code']
         description = row['Synonym']
        
        # Create Entry
         entry = UcumEntry.new(:code => code,:name => name, :description => description )


         if !class_name_hash.has_key?(class_name)
            # First Occurence of Class
            class_node = Node.new(:name => class_name , :parent => root_node)
            class_node.save!
            class_name_hash[class_name]=class_node
         end
       # Hang Entry in Node
       entry.node=class_name_hash[class_name]
       entry.save!

      end

      #Save Everything
      root_node.save!
      catalog.save!
     

     end
   end
  
end
