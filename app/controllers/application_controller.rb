class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  after_action :user_activity

  include Pundit::Authorization
  include PublicActivity::StoreController

  include Pagy::Backend

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :set_global_variables, if: :user_signed_in?
  def set_global_variables
    @ransack_courses = Course.ransack(params[:courses_search], search_key: :courses_search)
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end

  def user_activity
    current_user.try :touch
  end
end
