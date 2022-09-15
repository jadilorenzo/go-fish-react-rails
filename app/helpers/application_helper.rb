module ApplicationHelper
  def login_check
    return if at_login_page
    return if at_signup_page
    redirect_to login_path if !logged_in?
  end

  def at_login_page
    params[:action] == 'new' && (params[:controller] == 'session' || params[:controller] == 'users')
  end

  def at_signup_page
    params[:action] == 'create' && (params[:controller] == 'session' || params[:controller] == 'users')
  end

  def seconds_to_time(seconds)
    "#{pluralize(seconds.in_hours.to_i, 'hour')}, #{pluralize(seconds.in_minutes.to_i % 60, 'minute')}, #{pluralize(seconds.to_i % 60, 'second')}"
  end

  def icon_name_for_flash(type)
    case type
    when 'notice'
      'check_circle'
    when 'alert'
      'cancel'
    else
        type
    end
  end
end
