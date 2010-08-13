module TasksHelper
  def task_is_open?(state)
    if state == Task.state_open
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
end
