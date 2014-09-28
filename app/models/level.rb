class Level < ActiveRecord::Base
  has_many :missions

  def self.get_level_from_experience(experience)
    Level.where("sufficiency <= ?", experience)
      .order('sufficiency DESC').first
  end

  def next
    Level.where("sufficiency > ?", self.sufficiency)
      .order('sufficiency ASC').first
  end
end
