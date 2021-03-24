class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

 protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :email])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :plain_password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :plain_password, :business_name, :business_unit])
  end

  def update_user_business
    if current_user.business_unit.blank? || current_user.business_name.blank?
      redirect_to '/business-form'
    end
  end

  def update_business?
    user_signed_in? && !devise_controller? 
  end
end
