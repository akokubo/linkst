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

  def tone(level, random)
    level_value = level.value
    level_value = (level_value - 1.0) / 8.0

    x = random.rand(1.0)
    a = 4.0 / level_value
    z = 1.0
    value = (-Math.log(1.0 / x - 1.0) / a + level_value) / z
    if value > 1.0
      value = 1.0
    elsif value < 0.0
      value = 0.0
    end

    tone_level_value = value
    tone_level_value = (tone_level_value * 8 + 1).to_i

    tone_level = Level.find_by(value: tone_level_value)
    tone_level
  end

  def reassign_missions
    self.assigns.destroy_all

    categories = Category.all

    random = Random.new

    categories.each do |category|
      status = self.statuses.find_by(category_id: category.id)
      level = Level.get_level_from_experience(status.experience)
      mission_level = tone(level, random)
      missions = Mission.where(category_id: category.id, level_id: mission_level.id)

      missions_count = missions.count
      index = random.rand(missions_count)
      mission = missions[index]
      self.assigns.create(mission_id: mission.id)
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
