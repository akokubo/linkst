class AddJapaneseNameToRole < ActiveRecord::Migration
  def change
    add_column :roles, :japanese_name, :string
  end
end
