class Users::SessionsController < Devise::SessionsController
  # def new
  #   super
  # end

  def create
    super
    award_web_access_bonus!
  end

  private

    def award_web_access_bonus!
      puts "\e[31maward_web_access_bonus\e[0m"
      puts "\e[31m#{current_user.recent_web_access_bonus_awarded_on}\e[0m"
      puts "\e[31m#{!current_user.recent_web_access_bonus_awarded_on}\e[0m"
      puts "\e[31m#{Date.today}\e[0m"
      if current_user.recent_web_access_bonus_awarded_on
        puts "\e[31m#{current_user.recent_web_access_bonus_awarded_on < Date.today}\e[0m"
      end
      puts "\e[31m#{!current_user.recent_web_access_bonus_awarded_on || current_user.recent_web_access_bonus_awarded_on < Date.today}\e[0m"


      user = User.find(current_user.id)
      if !user.recent_web_access_bonus_awarded_on || user.recent_web_access_bonus_awarded_on < Date.today
        mission = Mission.find_by(description: 'Webサイトアクセスボーナス')
        history = History.new(user_id: current_user.id, mission_id: mission.id)
        history.recent_experience = user.total_experience
        mission.acquisitions.each do |acquisition|
          category_id = acquisition.category_id
          status = user.statuses.find_by(category_id: category_id)
          status.experience += acquisition.experience
          status.save
        end
        history.experience = user.reload.total_experience
        history.save
        user.update(recent_web_access_bonus_awarded_on: Date.today)
      end
    end
end
