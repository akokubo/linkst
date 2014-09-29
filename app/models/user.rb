class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :role
  has_many :statuses
  has_many :histories
  has_many :assigns
  belongs_to :seminar

  def total_experience
    experience = 0
    self.statuses.each do |status|
      experience += status.experience
    end
    experience
  end

  def average_level
    average_experience = total_experience / 3
    Level.get_level_from_experience(average_experience)
  end

  def reassign_missions
    assigns = self.assigns
    missions = Mission.all
    missions_count = missions.count
    random = Random.new
    assigns.each do |assign|
      index = random.rand(missions_count)
      assign.mission_id = missions[index].id
      assign.save
    end
  end
end
