class Category < ActiveRecord::Base
  has_many :missions, dependent: :destroy
  has_many :acquisitions, dependent: :destroy
  has_many :statuses, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
