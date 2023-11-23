class BigDecimal
  def as_currency(currency)
    Money.from_amount(self, currency)
  end
end