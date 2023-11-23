# app/models/concerns/money_convertible.rb
module MoneyConvertible
  extend ActiveSupport::Concern
  
  def amount_as_currency
    Money.from_amount(self.amount, self.family.currency)
  end
end
  