class Acquisition < ActiveRecord::Base
  belongs_to :mission
  belongs_to :category
end
