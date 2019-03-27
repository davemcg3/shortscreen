class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # this is poorly done but you didn't want users; I'm just showing you I know where this goes
  # If I wanted this terrible thing in production I would put that password in an environment variable so that it wasn't
  # available in github, but since I actually want you to be able to see it, here it is.
  # this should be sending a jwt token to a service which decodes it and authorizes
  # I used :password because it's automatically filtered in the logs (/config/initializers/filter_parameter_logging.rb)
  def authenticate(password=params[:password])
    if (password == "12180 Millennium" || session[:authenticated] == true)
      session[:authenticated] = true
      return
    end
    false
  end

  def clear_authentication
    session.delete :authenticated
  end
end
