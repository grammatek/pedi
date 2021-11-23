# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  include SetCurrentRequestDetails
  around_action :switch_locale

  # React on locale parameter, given via URL
  def switch_locale(&action)
    locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = locale
    I18n.with_locale(locale, &action)
  end

  # Add current locale to every url automatically as parameter
  def default_url_options
    { locale: I18n.locale }
  end
end
