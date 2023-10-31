class CreateBudgetAssignees < ActiveRecord::Migration[7.0]
  def change
    create_table :budget_assignees do |t|
      t.belongs_to :budget, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :percentage
    end
  end
end
