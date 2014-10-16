class AddIndexToUsersIdm < ActiveRecord::Migration
  def change
    add_index :users, :idm, unique: true
  end
end
