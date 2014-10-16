class WelcomeController < ApplicationController
  def index
    statuses = Status.group(:user_id)
      .select('user_id, SUM(experience) AS total_experience')
      .order('total_experience DESC').limit(5)
    @ranking = []
    statuses.each do |status|
      @ranking << User.find(status.user_id)
    end

    @histories = History.order('created_at DESC').limit(5)
  end

  def about
  end

  def contact
  end
end
