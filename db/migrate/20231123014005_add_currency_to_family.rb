class AddCurrencyToFamily < ActiveRecord::Migration[7.0]
  def change
    add_column :families, :currency, :string
  end
end
