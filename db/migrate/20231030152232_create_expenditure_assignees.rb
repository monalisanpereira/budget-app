class CreateExpenditureAssignees < ActiveRecord::Migration[7.0]
  def change
    create_table :expenditure_assignees do |t|
      t.belongs_to :expenditure, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.integer :percentage
      t.timestamps
    end
  end
end
