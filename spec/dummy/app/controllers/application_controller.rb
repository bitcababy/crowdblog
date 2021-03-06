class ApplicationController < ActionController::Base
  protect_from_forgery

  # Overwriting the sign_out redirect path method
  def after_sign_in_path_for(resource_or_scope)
    crowdblog_url
  end

  def authenticate!
    # sign out the user if trying to sign another user
    sign_out current_user if params['auth_token'] && current_user

    # if no one signed in, use the default user
    unless user_signed_in?
      user = Crowdblog::User.find_by_email('foo@crowdint.com') || Crowdblog::User.create!(email: 'foo@crowdint.com', is_publisher: true)
      sign_in user
    end
  end

end
