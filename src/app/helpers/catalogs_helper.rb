module CatalogsHelper
  def show_tree catalog
     render :partial => 'shared/catalog_tree', :locals => {:catalog=>catalog , :checkbox => false }
  end

  def radio_tree catalog ,form_html_id, param_name
      render :partial => 'shared/catalog_tree', :locals => {:catalog=>catalog , :checkbox => 'single', :form_html_id =>form_html_id, :param_name=> param_name }
  end

  def checkbox_tree catalog ,form_html_id, param_name
      render :partial => 'shared/catalog_tree', :locals => {:catalog=>catalog , :checkbox => 'multi', :form_html_id =>form_html_id, :param_name=> param_name }
  end
end
