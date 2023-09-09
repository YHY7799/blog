class ApplicationController < ActionController::Base

    around_action :switch_locale

      # Prevent resetting locale to default after login.
  def reset_session
    super
    session[:locale] = I18n.locale
  end

  def switch_locale(&action)
    session[:locale] = params[:locale] || session[:locale] || I18n.default_locale
    I18n.with_locale(session[:locale], &action)
  end

end
