# To change this template, choose Tools | Templates
# and open the template in the editor.

class Importer::LoincCatalogImporter 
  def import catalog,file
     # Create the Hash for Node Names
      class_name_hash=Hash.new
      302.times { file.readline  }
      csv=CSV.new(file,:col_sep => "\t",:headers => :first_row)
     # Create the Catalogs Helper Root Node
      
      catalog.transaction do
        root_node=catalog.create_root_node
        root_node.name=catalog.catalog_type.name + " Root Node"
        root_node.save
        # Iterate over Rows
        while (row=csv.shift)
          #  Get The Values
           class_name =  row['CLASS']
           description = row['COMPONENT']+":"
           if row['PROPERTY']
           description +=row['PROPERTY']
           end
           description+=":"
           if row['TIME_ASPCT']
           description +=row['TIME_ASPCT']
           end
             description+=":"
           if row['SYSTEM']
           description +=row['SYSTEM']
           end
             description+=":"
           if row['SCALE_TYP']
           description +=row['SCALE_TYP']
           end
             description+=":"
           if row['METHOD_TYP']
              description +=row['METHOD_TYP']
           end
           name = row ['LONG_COMMON_NAME']
           code = row['LOINC_NUM']
           type = row['CLASSTYPE']
            if type=="1" # Laboratory
              if row['PROPERTY']!="-" #Panel Elements
                 # Create Entry
                  entry = FieldEntry.new(:code => code,:name => name, :description => description )
                  if !class_name_hash.has_key?(class_name)
                     # First Occurence of Class
                    class_node = root_node.children.create(:name => class_name)
                    class_node.save
                    class_name_hash[class_name]=class_node
                  end
              # Hang Entry in Node
              entry.node=class_name_hash[class_name]
              entry.save
              end
          end
        end

      #Save Everything

      catalog.save
      end # End of Transaction
  end
end
