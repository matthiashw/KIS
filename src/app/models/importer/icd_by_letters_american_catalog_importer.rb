# To change this template, choose Tools | Templates
# and open the template in the editor.

class Importer::IcdByLettersAmericanCatalogImporter
   def import catalog,file


      # Create the Hash for Node Names
      codehash=Hash.new

      # Create CSV Object from File
      csv=CSV.new(file,{:col_sep => " " })

     catalog.transaction do

      # Create the Catalogs Helper Root Node
      
      root_node=Node.new
      root_node.name=catalog.catalog_type.name + " Root Node"
      catalog.root_node=root_node

      # Iterate over Rows
      while (row=csv.shift)
        #  Get The Values
        code =  row[0]
        row[0] = ""

        # Create Entry
        entry = IcdEntry.new(:code => code,:name => row.join(" "))
         entry.node=root_node


         partial_code=""
         last_node=nil
         pos=1
         code.each_char do |code_element|

           if pos<3
            partial_code << code_element

            if !codehash.has_key?(partial_code)
                if last_node==nil
                  node = Node.new(:name => code_element , :parent => root_node)
                else
                  node = Node.new(:name => code_element , :parent => last_node)
                end
                node.save!
                codehash[partial_code]=node
           end
           last_node=codehash[partial_code]

           else
             entry.node=last_node
             break

           end

           pos=pos+1
         end
      entry.save!

      end

      #Save Everything
      root_node.save!
      catalog.save!

     end
     end
   end

