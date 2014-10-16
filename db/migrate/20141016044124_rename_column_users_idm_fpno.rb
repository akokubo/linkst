class RenameColumnUsersIdmFpno < ActiveRecord::Migration
  def change
    rename_column :users, :idm, :fpno
  end
end
