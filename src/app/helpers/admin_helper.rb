module AdminHelper
  def is_ok_or_error(status)

    if status
      activeclass = "messages ok"
    else
      activeclass = "messages error"
    end

    activeclass
  end
end
