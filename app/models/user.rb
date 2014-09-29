class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :role
  belongs_to :seminar
  has_many :statuses, dependent: :destroy
  has_many :histories, dependent: :destroy
  has_many :assigns, dependent: :destroy

  after_create :add_statuses_and_assigns

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

  private

    def add_statuses_and_assigns
      level_sufficiency_minimum = Level.minimum(:sufficiency)
      level = Level.find_by(sufficiency: level_sufficiency_minimum)

      categories = Category.all

      categories.each do |category|
        self.statuses.create(
          category_id: category.id,
          experience: 0)
        first_mission = Mission.find_by(category_id: category.id, level_id: level.id)
        self.assigns.create(mission_id: first_mission.id)
      end

    end
end
