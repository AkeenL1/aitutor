class RemoveSectionIdFromCourses < ActiveRecord::Migration[7.2]
  def change
    remove_column :courses, :section_id, :integer
  end
end
