class TurboFailureApp < Devise::FailureApp
  def respond
    if request_format == :turbo_stream
      turbo_stream_response
    else
      super
    end
  end

  def skip_format?
    %w[html turbo_stream */*].include? request_format.to_s
  end

  private

  def turbo_stream_response
    self.status = 200
    self.content_type = "text/vnd.turbo-stream.html"
    self.response_body = render_turbo_stream_template
  end

  def render_turbo_stream_template
    scope_name = warden_options[:scope]

    # Extract controller name from the request path
    # e.g., "/users/sign_in" -> "sessions", "/users/password" -> "passwords"
    controller_name = extract_controller_name

    # Use singular form for template path (e.g., "user" not "users")
    template_path = "devise/#{scope_name.to_s.singularize}/#{controller_name}/create"

    # Build a resource with the submitted params to show in the form
    resource = build_resource_from_params(scope_name)

    # Render the turbo_stream template with the flash message and resource
    ApplicationController.render(
      template: template_path,
      formats: [ :turbo_stream ],
      layout: false,
      assigns: {
        resource: resource,
        resource_name: scope_name,
        devise_mapping: Devise.mappings[scope_name],
        controller_name: controller_name
      }, locals: {
        flash: { alert: i18n_message },
        resource: resource,
        resource_name: scope_name,
        devise_mapping: Devise.mappings[scope_name],
        controller_name: controller_name
      }
    )
  end

  def extract_controller_name
    # Parse the request path to determine the Devise controller
    # e.g., "/users/sign_in" -> "sessions"
    # e.g., "/users/password" -> "passwords"
    # e.g., "/users/confirmation" -> "confirmations"
    path = request.path

    case path
    when /sign_in|sign_out/
      "sessions"
    when /password/
      "passwords"
    when /sign_up|cancel/
      "registrations"
    when /confirmation/
      "confirmations"
    when /unlock/
      "unlocks"
    else
      "sessions" # default fallback
    end
  end

  def build_resource_from_params(scope_name)
    # Get the model class (e.g., User)
    resource_class = scope_name.to_s.classify.constantize

    # Build a new resource with the submitted params (email, etc.)
    # This preserves the form data so the user doesn't have to re-type
    resource = resource_class.new

    # Try to get the authentication key from params (usually email)
    auth_key = Devise.authentication_keys.first
    if request.params[scope_name] && request.params[scope_name][auth_key]
      resource.send("#{auth_key}=", request.params[scope_name][auth_key])
    end

    resource
  end
end
