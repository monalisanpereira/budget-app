class AddFamilyRefToExpenditures < ActiveRecord::Migration[7.0]
  def change
    add_reference :expenditures, :family, foreign_key: true
  end
end
