
# frozen_string_literal: true

class Administrators::SessionsController < Devise::SessionsController
  # Use default Devise authentication - it will work with STI if configured properly
  # The key is that the route uses devise_for :administrators with class_name: "Administrator"

  protected

  def after_sign_in_path_for(resource)
    admin_root_path
  end
end
