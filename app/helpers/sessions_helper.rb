# frozen_string_literal: true

module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user?(user)
    user == current_user
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns the tts voice selected by user
  def current_tts_voice
    if (user_id = session[:user_id])
      @user = User.find_by(id: user_id)
      @current_voice = @user.tts_voice
    end
    return unless @user

    unless @current_voice
      voice = tts_voices&.first
      if voice
        @user.tts_voice = voice
        @user.save
        @current_voice = voice
      else
        'No voices available'
      end
    end
    @current_voice
  end

  # Returns all available tts voices
  def tts_voices
    if session[:available_tts_voices].nil?
      session[:available_tts_voices] = TtsService.voices
    end
    session[:available_tts_voices]
  end

  def logged_in?
    !current_user.nil?
  end

  def logged_in_as_admin?
    return current_user.admin if logged_in?

    false
  end

  # Redirects to stored location (or to the default)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
