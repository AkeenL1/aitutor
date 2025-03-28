class AddGoalToCourses < ActiveRecord::Migration[7.2]
  def change
    add_column :courses, :goal, :string
  end
end
