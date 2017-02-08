class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :restore_locale

  def url_options
    { :locale => I18n.locale }.merge(super)
  end

  private

  def restore_locale
    I18n.locale = params[:locale] if params[:locale]
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
end
