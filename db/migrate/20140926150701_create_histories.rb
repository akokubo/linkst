class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.references :user, index: true
      t.references :mission, index: true

      t.timestamps
    end
  end
end
