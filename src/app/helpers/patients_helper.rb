module PatientsHelper

  # check if the given patient id is the
  # active one, and if so returns
  # a string for css class
  def css_for_active_patient(pid)
    cssclass = "inactive"

    if current_active_patient != nil
      if current_active_patient.id == pid
        cssclass = "active"
      end
    end

    cssclass
  end
end
