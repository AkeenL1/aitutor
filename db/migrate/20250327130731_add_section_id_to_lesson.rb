class AddSectionIdToLesson < ActiveRecord::Migration[7.2]
  def change
    add_reference :lessons, :section, null: false, foreign_key: true
  end
end
