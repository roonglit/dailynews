# frozen_string_literal: true

class Members::SessionsController < Devise::SessionsController
  # Use default Devise authentication - it will work with STI if configured properly
  # The key is that the route uses devise_for :members with class_name: "Member"
end
