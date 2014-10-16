class RenameColumnLevelsSufficiencyToRequiredExperience < ActiveRecord::Migration
  def change
    rename_column :levels, :sufficiency, :required_experience
  end
end
