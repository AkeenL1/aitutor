class AddLessonsTitleMigration < ActiveRecord::Migration[7.2]
  def change
    add_column :lessons, :title, :string
  end
end
