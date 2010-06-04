module CatalogsHelper
  def xml_tree xml
  if !@shownode.entries.empty?
    @shownode.entries.each do |entry|
         xml.item :id => 'entry'+entry.id.to_s  ,
           :parent_id => 0,
           :state => "" do
            xml.content do
                xml.name h entry.code
            end
         end
      end
  end

 if !@shownode.children.empty?
   @shownode.children.each do |node|
        xml.item :id => node.id, :parent_id =>0, :state => 'closed' do
          xml.content do
             xml.name h node.name
          end
         end
      end

    end
  end
end
