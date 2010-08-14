module TasksHelper
  def task_is_open?(state)
    if state == Task.state_open
      return true
    end

    return false
  end

  def is_creator?(uid)
    if current_user.id == uid
      return true
    end

    return false
  end

  def task_is_inprogress?(state)
    if state == Task.state_inprogress
      return true
    end

    return false
  end
  
 def is_in_domain?(did)
    current_user.domains.each do |d|
      if d.id == did
        return true
      end
    end

    return false
  end
end
