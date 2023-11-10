class Budget < ApplicationRecord
  belongs_to :family
  has_many :expenditures
  has_many :budget_assignees, dependent: :destroy
  has_many :assignees, through: :budget_assignees, source: :user

  accepts_nested_attributes_for :budget_assignees, reject_if: proc { |attributes| attributes['percentage'].to_i.zero? }

  enum :period, [ :month, :week, :day, :two_weeks, :two_months, :three_months, :six_months, :year ]

  validates :name, presence: true
  validates :amount, presence: true
  validates :period, presence: true

  def amount_left
    result = amount
    self.expenditures.where(date: Date.current.beginning_of_month..Date.current.end_of_month).each do |expenditure|
      result = result - expenditure.amount
    end
    result
  end
end
