class Mission < ActiveRecord::Base
  belongs_to :category
  belongs_to :level
  has_many :acquisitions, dependent: :destroy
  has_many :histories
  has_many :assigns

  accepts_nested_attributes_for :acquisitions
end
