class Mission < ActiveRecord::Base
  belongs_to :category
  belongs_to :level
  has_many :acquisitions
end
