class FixCoursesSectionId < ActiveRecord::Migration[7.2]
  def change
    change_column_null :courses, :section_id, true
  end
end
