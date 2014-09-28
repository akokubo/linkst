class ChangeMissionsDescriptionToString < ActiveRecord::Migration
  def change
    change_column :missions, :description, :string
  end
end
