class RemoveLessonIdFromSection < ActiveRecord::Migration[7.2]
  def change
    remove_column :sections, :lesson_id, :integer
  end
end
