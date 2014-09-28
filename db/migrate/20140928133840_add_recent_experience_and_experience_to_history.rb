class AddRecentExperienceAndExperienceToHistory < ActiveRecord::Migration
  def change
    add_column :histories, :recent_experience, :integer
    add_column :histories, :experience, :integer
  end
end
