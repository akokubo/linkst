class Level < ActiveRecord::Base
  has_many :missions

  def self.get_level_from_experience(experience)
    Level.where("required_experience <= ?", experience)
      .order('required_experience DESC').first
  end

  def next
    Level.where("required_experience > ?", self.required_experience)
      .order('required_experience ASC').first
  end
end
