class CreateSections < ActiveRecord::Migration[5.2]
  def change
    create_table :sections do |t|
      t.string :title
      t.integer :course_id
      t.integer :row_order
      t.timestamps
    end
    add_index :sections, :course_id
    add_index :sections, :row_order
  end
end

