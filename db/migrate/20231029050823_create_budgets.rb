class CreateBudgets < ActiveRecord::Migration[7.0]
  def change
    create_table :budgets do |t|
      t.belongs_to :family, foreign_key: true
      t.string :name
      t.decimal :amount
      t.integer :created_by
      t.timestamps
    end
  end
end
