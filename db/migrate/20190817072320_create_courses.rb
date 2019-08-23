class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.text :description
      t.decimal :cost 
      t.string :title
      t.integer :user_id
      t.timestamps
    end
    add_index :courses, :user_id
  end
end