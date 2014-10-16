class CreateAcquisitions < ActiveRecord::Migration
  def change
    create_table :acquisitions do |t|
      t.references :mission, index: true
      t.references :category, index: true
      t.integer :experiences

      t.timestamps
    end
  end
end
