class AddSeminarIdToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :seminar, index: true
  end
end
