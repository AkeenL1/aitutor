class RemoveLessonIdFromLesson < ActiveRecord::Migration[7.2]
  def change
    remove_column :lessons, :lesson_id, :integer
  end
end
