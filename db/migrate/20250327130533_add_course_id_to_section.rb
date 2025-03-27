class AddCourseIdToSection < ActiveRecord::Migration[7.2]
  def change
    add_reference :sections, :course, null: false, foreign_key: true
  end
end
