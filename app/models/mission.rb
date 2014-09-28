class Mission < ActiveRecord::Base
  belongs_to :category
  belongs_to :level
  has_many :acquisitions, dependent: :destroy
  has_many :histories
  has_many :assigns

  accepts_nested_attributes_for :acquisitions

=begin
  after_initialize :add_acquisitions

  private

    def add_acquisitions
      if new_record?
        categories = Category.all
        categories.each do |category|
          self.acquisitions.build(category_id: category.id, experience: 0)
        end
      end
    end
=end
end
