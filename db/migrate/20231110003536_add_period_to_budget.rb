class AddPeriodToBudget < ActiveRecord::Migration[7.0]
  def change
    add_column :budgets, :period, :integer
  end
end
