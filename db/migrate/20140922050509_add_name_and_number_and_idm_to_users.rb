class AddNameAndNumberAndIdmToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :number, :string
    add_column :users, :idm, :string
  end
end
