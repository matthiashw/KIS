module CatalogsHelper
  def xml_tree xml
  if !@shownode.entries.empty?
    @shownode.entries.each do |entry|
         xml.item :id => 'entry'+entry.id.to_s  ,
           :parent_id => 0,
           :state => "" do
            xml.content do
                xml.name do
                  xml.cdata! "<b>Code:</b> "+entry.code+"<br/> <b>Description:</b> "+entry.description
                end
            end
         end
      end
  elsif !@shownode.children.empty?
   @shownode.children.each do |node|
        xml.item :id => node.id, :parent_id =>0, :state => 'closed' do
          xml.content do
             xml.name h node.name
          end
         end
      end

  else
   xml.item
  end
 end
end
