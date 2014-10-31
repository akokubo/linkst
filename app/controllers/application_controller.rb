class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  class Forbidden < StandardError; end
  class NotFound < StandardError; end

  protected

  def configure_permitted_parameters
#    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :number, :role_id, :name, :fpno, :card_number) }
#    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :current_password, :number, :role_id, :name, :fpno, :card_number) }
  end

  if Rails.env.production?
    rescue_from Exception, with: :rescue_500
    rescue_from ActionController::RoutingError, with: :rescue_404
    rescue_from ActiveRecord::RecordNotFound, with: :rescue_404
  end

  rescue_from Forbidden, with: :rescue_403
  rescue_from NotFound, with: :rescue_404

  def rescue_403(exception)
    render "errors/forbidden", status: 403, layout: "error"
  end

  def rescue_404(exception)
    render "errors/not_found", status: 404, layout: "error"
  end

  def rescue_500(exception)
    render "errors/internal_server_error", status: 500, layout: "error"
  end


  protected

    def award_web_access_bonus!
      mission = Mission.find_by(description: 'Webサイトアクセスボーナス')
      user = current_user
      today_date = Date.today
      if user
        if !user.recent_web_access_bonus_awarded_on || user.recent_web_access_bonus_awarded_on < today_date
          user.update(recent_web_access_bonus_awarded_on: today_date)
          history = History.new(user_id: user.id, mission_id: mission.id)
          history.recent_experience = user.total_experience
          history.experience = history.recent_experience + 8
          history.save
          mission.acquisitions.each do |acquisition|
            category_id = acquisition.category_id
            status = user.statuses.find_by(category_id: category_id)
            status.experience += acquisition.experience
            status.save
          end
        end
      end
    end
end
