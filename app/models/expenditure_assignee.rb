class ExpenditureAssignee < ApplicationRecord
  include MoneyConvertible

  belongs_to :user
  belongs_to :expenditure
  has_one :family, through: :expenditure, autosave: false

  def beared_cost
    (self.expenditure.amount / 100 * self.percentage).as_currency(self.family.currency)
  end
end
