module CatalogsHelper
  def show_tree catalog
     render :partial => 'shared/catalog_tree', :locals => {:catalog=>catalog , :checkbox => false }
  end

  def radio_tree catalog ,form_html_id, param_name ,selected_entry=-1
      path="/0"
      if selected_entry!= -1
        patharray=Array.new
        entry=Entry.find selected_entry
        node=entry.node
        while(node.parent!=nil)
          patharray.push(node.id)
          node=node.parent
        end
        patharray.reverse.each do |pathelement|
          path = path +"/" + pathelement.to_s
        end
        path=path + "/_" + selected_entry.id.to_s
      end
      render :partial => 'shared/catalog_tree', :locals => {:catalog=>catalog , :checkbox => 'single', :form_html_id =>form_html_id, :param_name=> param_name ,:selected_node => path}
  end

  def checkbox_tree catalog ,form_html_id, param_name 
      render :partial => 'shared/catalog_tree', :locals => {:catalog=>catalog , :checkbox => 'multi', :form_html_id =>form_html_id, :param_name=> param_name  }
  end
end
