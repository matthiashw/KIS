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
        root_node=Node.new
        root_node.name=catalog.catalog_type.name + " Root Node"
        catalog.root_node=root_node
        
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
           startcode=code[0,2]
            if type=="1" # Laboratory
              if !(class_name.starts_with? "PANEL.") #Panel Elements
                 # Create Entry
                  entry = FieldEntry.new(:code => code,:name => name, :description => description )
                  fielddef = FieldDefinition.new(:is_active => false,:input_type => 0,:field_entry => entry)

                  if !class_name_hash.has_key?(class_name)
                     # First Occurence of Class
                     class_node = Node.new(:name => class_name , :parent => root_node)
                    class_node.save
                    class_name_hash[class_name]=class_node
                  end
                  if !class_name_hash.has_key?(class_name + startcode)
                    code_node = Node.new(:name => startcode , :parent => class_name_hash[class_name])
                    code_node.save
                    class_name_hash[class_name + startcode] = code_node
                  end
              # Hang Entry in Node
              entry.node=class_name_hash[class_name + startcode]
              entry.save
              fielddef.save
              end
          end
        end

      #Save Everything
      root_node.save
      catalog.save
      end # End of Transaction
  end
end
