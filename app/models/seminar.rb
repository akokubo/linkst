class Seminar < ActiveRecord::Base
  has_one :user
  validates :name, presence: true, uniqueness: true
end
