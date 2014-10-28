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

  validates :number, presence: true
  validates :role_id, presence: true
  validates :name, presence: true
  validates :fpno, presence: true, uniqueness: true
  validates :card_number, presence: true, uniqueness: true

  before_save :upcase_fpno
  after_create :add_statuses_and_assigns

  def total_experience
    experience = 0
    self.statuses.each do |status|
      experience += status.experience
    end
    experience
  end

  def average_level
    categories = Category.all.order('id ASC')
    average_experience = total_experience / categories.count
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

    categories = Category.all.order('id ASC')

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

  def has_role?(name)
    self.role && self.role.name == name
  end

  private

    def add_statuses_and_assigns
      level_required_experience_minimum = Level.minimum(:required_experience)
      level = Level.find_by(required_experience: level_required_experience_minimum)

      categories = Category.all.order('id ASC')


      categories.each do |category|
        self.statuses.create(
          category_id: category.id,
          experience: 0)
=begin
        first_mission = Mission.find_by(category_id: category.id, level_id: level.id)
        self.assigns.create(mission_id: first_mission.id)
=end
      end

      missions_description = %w(書くものを持ってくる 手洗いうがいをする 教科書を持ってくる 友人と共通の話題／趣味で仲を深める)
      missions_description.each do |mission_description|
        first_mission = Mission.find_by(description: mission_description)
        self.assigns.create(mission_id: first_mission.id)
      end
    end

    def upcase_fpno
      self.fpno = self.fpno.upcase
    end
end
