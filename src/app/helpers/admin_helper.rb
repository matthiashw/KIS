module AdminHelper
  def is_ok_or_error(error)

    if error
      activeclass = "messages error"
    else
      activeclass = "messages ok"
    end

    activeclass
  end
end
