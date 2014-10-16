class Role < ActiveRecord::Base
  has_many :users
  validates :name, presence: true
  validates :japanese_name, presence: true

end
