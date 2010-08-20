module UsersHelper
  def is_admin?(uid)
    cssclass = ""
    if uid == 1
      cssclass = "yellow"
    end

    cssclass
  end

  def homepages(user_id)
    h = { t("user.homepage.patient_index")      => patients_path,
          t("user.homepage.task_index")         => tasks_path,
          t("user.homepage.appointment_index")  => appointments_path,
          t("user.homepage.administration")     => admin_index_path }

    unless user_id.nil?
      user = User.find_by_id(user_id)

      if user.has_permission?("view_own_task")
        mytasks = { t("user.homepage.task_mytasks") => mytasks_path(:user_id => user_id)}
        h.merge!(mytasks)
      end

      if user.has_permission?("view_domain_task")
        domaintasks = { t("user.homepage.task_domaintasks") => domaintasks_path(:user_id => user_id)}
        h.merge!(domaintasks)
      end
      
    end
    
    h
  end
end
