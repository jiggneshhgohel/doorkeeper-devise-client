class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def doorkeeper
    oauth_data = request.env["omniauth.auth"]

    Rails.logger.debug ">>>>>>>>>>>>> oauth_data: #{oauth_data}"

    @user = User.find_or_create_for_doorkeeper_oauth(oauth_data)
    @user.update_doorkeeper_credentials(oauth_data)
    @user.save

    sign_in_and_redirect @user
  end

  protected

  def after_omniauth_failure_path_for(scope)
    root_path
  end
end
