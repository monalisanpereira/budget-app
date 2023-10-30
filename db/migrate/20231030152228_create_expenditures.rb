class CreateExpenditures < ActiveRecord::Migration[7.0]
  def change
    create_table :expenditures do |t|
      t.belongs_to :budget, foreign_key: true
      t.text :description
      t.decimal :amount
      t.integer :created_by
      t.date :date
      t.timestamps
    end
  end
end
