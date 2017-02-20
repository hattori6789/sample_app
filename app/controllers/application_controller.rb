class ApplicationController < ActionController::Base
  require 'geoip'
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :set_locale

  private

  def set_locale
    extracted_locale = params[:locale] ||
    extract_locale_from_subdomain ||
    extract_locale_from_accept_language ||
    extract_locale_from_ip
    I18n.locale = (I18n::available_locales.include? extracted_locale.to_sym) ? extracted_locale : I18n.default_locale
  end

  def extract_locale_from_subdomain
    request.subdomains.first
  end

  def extract_locale_from_accept_language
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

  def extract_locale_from_ip
    @geoip ||= GeoIP.new(Rails.root.join("lib/GeoIP.dat"))
    country_location = @geoip.country(request.remote_ip)
    country_location.country_code2.downcase
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t('please_log_in')
      redirect_to login_url
    end
  end
end
