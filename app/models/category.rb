class Category < ActiveRecord::Base
  has_many :missions
  has_many :acquisitions
end
