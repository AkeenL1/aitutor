class MakeGoalOnCoursesNullable < ActiveRecord::Migration[7.2]
  def change
    change_column_null :courses, :goal, true
  end
end
