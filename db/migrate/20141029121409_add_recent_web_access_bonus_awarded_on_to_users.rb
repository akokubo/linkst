class AddRecentWebAccessBonusAwardedOnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :recent_web_access_bonus_awarded_on, :date
  end
end
