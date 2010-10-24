module CatalogsHelper
  def show_tree catalog
     if catalog.root_node.children.empty? && catalog.root_node.entries.empty?
         render :partial => 'shared/empty_catalog'
     else
      render :partial => 'shared/catalog_tree', :locals => {:catalog=>catalog , :checkbox => false }
     end
  end

  def radio_tree catalog ,form_html_id, param_name ,selected_entry_id = -1
    if catalog.root_node.children.empty? && catalog.root_node.entries.empty?
         render :partial => 'shared/empty_catalog'
     else
      path="/0"
      selected_nodes="";
      if selected_entry_id!= -1
        selected_nodes="\'_"+selected_entry_id.to_s+"\'"
        patharray=Array.new
        entry=Entry.find selected_entry_id
        node=entry.node
        while(node.parent!=nil)
          patharray.push(node.id)
          node=node.parent
        end
        patharray.reverse.each do |pathelement|
          path = path +"/" + pathelement.to_s
        end
       
      end
      render :partial => 'shared/catalog_tree', :locals => {:catalog=>catalog , :checkbox => 'single', :form_html_id =>form_html_id, :param_name=> param_name ,:selected_nodes => selected_nodes ,:selected_node_path => path}

    end
  end

  def checkbox_tree catalog ,form_html_id, param_name , selected_entry_ids = []
   if catalog.root_node.children.empty? && catalog.root_node.entries.empty?
         render :partial => 'shared/empty_catalog'
    else
      selected_nodes=""
      selected_entry_ids.each do |node_id|
        if selected_nodes!=""
          selected_nodes+=","
        end
        selected_nodes+="\'_"+node_id.to_s+"\'"
      end
      render :partial => 'shared/catalog_tree', :locals => {:catalog=>catalog , :checkbox => 'multi', :form_html_id =>form_html_id, :param_name=> param_name ,:selected_nodes => selected_nodes  }
   end
  end

  def no_catalog_available application
   render :partial => 'shared/no_catalog_available', :locals => {:application => application}
  end
end
