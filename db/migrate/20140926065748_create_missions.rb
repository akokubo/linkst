class CreateMissions < ActiveRecord::Migration
  def change
    create_table :missions do |t|
      t.text :description
      t.references :category, index: true
      t.references :level, index: true

      t.timestamps
    end
  end
end
