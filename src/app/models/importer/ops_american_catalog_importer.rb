# To change this template, choose Tools | Templates
# and open the template in the editor.

class Importer::OpsAmericanCatalogImporter
   def import catalog,file

      # Create the Hash for Node Names
      codehash=Hash.new

      # Create CSV Object from File
      csv=CSV.new(file,{:col_sep => "|" })

     catalog.transaction do

      # Create the Catalogs Helper Root Node
      root_node=Node.new
      root_node.name=catalog.catalog_type.name + " Root Node"
      catalog.root_node=root_node
      # Iterate over Rows
      while (row=csv.shift)
        #  Get The Values
         code =  row[0]
         type1 = row[1]
         type2 = row[2]
         value1 = row[3]
         value2 = row[4]
         value3 = row[5]
         value4 = row[6]
         value5 = row[7]
         name = value1[2..value1.length]+", "+value2[2..value2.length]+", "+value3[2..value3.length]+", "+value4[2..value4.length]+", "+value5[2..value5.length]
         description = type1[2..type1.length]+", "+type2[2..type2.length]
        # Create Entry
         entry = OpsEntry.new(:code => code,:name => name, :description => description )
         entry.node=root_node
         
         partial_code=""
         last_node=nil
         pos=1
         code.each_char do |code_element|
          
           if pos<6
            partial_code << code_element
            if code_element!='Z'
            if !codehash.has_key?(partial_code)
                if last_node==nil
                  node = Node.new(:name => row[pos] , :parent => root_node)
                else
                  node = Node.new(:name => row[pos] , :parent => last_node)
                end
                node.save!
                codehash[partial_code]=node
           end
           last_node=codehash[partial_code]
            end
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

