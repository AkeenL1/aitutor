class CreateCourses < ActiveRecord::Migration[7.2]
  def change
    create_table :courses do |t|
      t.string :title
      t.string :level
      t.references :section, null: false, foreign_key: true

      t.timestamps
    end
  end
end
