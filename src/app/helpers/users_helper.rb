module UsersHelper
  def is_admin?(uid)
    cssclass = ""
    if uid == 1
      cssclass = "yellow"
    end

    cssclass
  end
end
