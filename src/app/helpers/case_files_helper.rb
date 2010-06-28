module CaseFilesHelper
  
  # check if the given case_file is the
  # active one, and if so returns
  # a string for css class
  def css_for_active_case_file(cf_id)
    cssclass = "inactive"
    
    if current_active_patient != nil
      if current_active_patient.active_case_file_id == cf_id
        cssclass = "active"
      end
    end

    cssclass
  end

end
