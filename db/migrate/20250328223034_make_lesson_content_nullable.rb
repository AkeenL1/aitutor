class MakeLessonContentNullable < ActiveRecord::Migration[7.2]
  def change
    change_column_null :lessons, :content, true
  end
end
