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

  before_action :set_visitor_info

  private

  def set_visitor_info
    cookies.permanent[:visitor_id] ||= SecureRandom.uuid
    cookies[:language_preference] ||= "ar"
    cookies[:visit_count] ||= 0
    cookies[:visit_count] = cookies[:visit_count].to_i + 1
    user_agent = request.user_agent
    platform = extract_platform(user_agent)
    device_type = extract_device_type(user_agent) # Modified line
    device_info = {
      browser: request.user_agent,
      platform: platform,
      ip_address: request.ip,
      # screen_resolution: "#{request.screen_width}x#{request.screen_height}",
      referrer: request.referer,
      cookies_enabled: cookies_enabled?,
      javascript_enabled: javascript_enabled?,
      device_type: device_type,
      browser_version: browser_version,
      connection_speed: connection_speed,
      user_authenticated: user_authenticated?
    }

    cookies[:device_info] = device_info.to_json
  end

  def cookies_enabled?
    cookies[:test_cookie] = '1'
    cookies.delete(:test_cookie)
    true
  rescue
    false
  end

  def javascript_enabled?
    cookies[:javascript_test] = '1'
    cookies.delete(:javascript_test)
    true
  rescue
    false
  end

  def extract_platform(user_agent)
    if user_agent =~ /iPad/
      'iPad'
    elsif user_agent =~ /iPhone/
      'iPhone'
    elsif user_agent =~ /Android/
      'Android'
    elsif user_agent =~ /Windows/
      'Windows'
    elsif user_agent =~ /Macintosh/
      'Macintosh'
    elsif user_agent =~ /Linux/
      'Linux'
    else
      'Unknown'
    end
  end

  def extract_device_type(user_agent)
    if user_agent =~ /iPad|iPhone|iPod/ # Updated pattern
      'iOS'
    elsif user_agent =~ /Android/
      'Android'
    elsif user_agent =~ /Windows Phone/
      'Windows Phone'
    elsif user_agent =~ /Windows/
      'Windows'
    elsif user_agent =~ /Macintosh/
      'Macintosh'
    elsif user_agent =~ /Linux/
      'Linux'
    else
      'Unknown'
    end
  end

  def browser_version
    agent = request.user_agent
    if agent =~ /MSIE/i
      'Internet Explorer'
    elsif agent =~ /Chrome/i
      'Chrome'
    elsif agent =~ /Safari/i
      'Safari'
    elsif agent =~ /Firefox/i
      'Firefox'
    elsif agent =~ /Opera/i
      'Opera'
    else
      'Unknown'
    end
  end

  def connection_speed
    # Implement your logic to estimate connection speed here
    # This can vary depending on the available data or libraries you use
    'Unknown'
  end

  def user_authenticated?
    # Implement your logic to determine user authentication status here
    # You can access the current user or session data to check if the user is authenticated or logged in
    false
  end
end