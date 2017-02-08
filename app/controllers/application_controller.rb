class ApplicationController < ActionController::Base
  require 'geoip'
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :set_locale

  private

  def set_locale
    extracted_locale = extract_locale_from_ip
    I18n.locale = (I18n::available_locales.include? extracted_locale.to_sym) ? extracted_locale : I18n.default_locale
  end

  def extract_locale_from_ip
    @geoip ||= GeoIP.new(Rails.root.join("lib/GeoIP.dat"))
    country_location = @geoip.country(request.remote_ip)
    country_location.country_code2.downcase
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
end
