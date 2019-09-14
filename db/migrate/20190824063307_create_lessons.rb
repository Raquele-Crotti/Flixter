class CreateLessons < ActiveRecord::Migration[5.2]
  def change
    create_table :lessons do |t|
      t.string :title
      t.string :subtitle
      t.integer :section_id
      t.integer :row_order
      t.timestamps
    end
    add_index :lessons, :section_id
    add_index :lessons, :row_order
  end
end
