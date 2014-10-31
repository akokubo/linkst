class WelcomeController < ApplicationController
  before_action :award_web_access_bonus!, only: [:index, :about, :contact]

  def index
    statuses = Status.group(:user_id)
      .select('user_id, SUM(experience) AS total_experience')
      .order('total_experience DESC').limit(5)
    @ranking = []
    statuses.each do |status|
      @ranking << User.find(status.user_id)
    end

    mission = Mission.find_by(description: 'Webサイトアクセスボーナス')
    @histories = History.where('mission_id != ?', mission.id).order('created_at DESC').limit(5)
  end

  def about
  end

  def contact
  end

  def not_found
    raise ApplicationController::RoutingError,
      "No route matches #{request.path.inspect}"
  end
end
