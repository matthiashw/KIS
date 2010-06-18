# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'spreadsheet'

class Importer::AtcCatalogImporter
   def import catalog,file
      book = Spreadsheet.open file
      sheet = book.worksheet 0
       catalog.transaction do
        root_node=Node.new
        root_node.name=catalog.catalog_type.name + " Root Node"
        catalog.root_node=root_node
        hangnode=[[root_node,""]]
        firstrow=true
        sheet.each do |row|
          if firstrow==true
            firstrow=false
           
          else
          if(row[0].length!=7)
             while row[0].length<=hangnode.last[1].length
               hangnode.pop
             end
             node = Node.new( :name => row[0]+" "+ row[1], :parent => hangnode.last[0])
             node.save!
             hangnode.push([node,row[0]])
          else
             entry=AtcEntry.new(:code => row[0],:name => row[1], :node => hangnode.last[0])
             entry.save!
          end
          end
        end
        root_node.save!
        catalog.save!
      end

  end
end
