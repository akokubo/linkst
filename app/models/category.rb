class Category < ActiveRecord::Base
  has_many :missions
  has_many :acquisitions
  has_many :statuses
end
