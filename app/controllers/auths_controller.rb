class AuthsController < ApplicationController
  # GET /logout
  # GET /logout.json
  def logout
    clear_authentication
    redirect_to new_link_url
  end
end
