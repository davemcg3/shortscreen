module ApplicationHelper
  def logout_button
    if session[:authenticated] == true
      " | ".concat(link_to('Logout', 'logout')).html_safe
    end
  end
end
