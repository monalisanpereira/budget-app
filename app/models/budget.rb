class Budget < ApplicationRecord
  include MoneyConvertible

  belongs_to :family
  has_many :expenditures
  has_many :budget_assignees, dependent: :destroy
  has_many :assignees, through: :budget_assignees, source: :user

  accepts_nested_attributes_for :budget_assignees, reject_if: proc { |attributes| attributes['percentage'].to_i.zero? }

  enum :period, [ :monthly, :weekly, :daily, :yearly ]

  validates :name, presence: true
  validates :amount, presence: true
  validates :period, presence: true
  validate  :presence_of_budget_assignees
  validate  :assignee_percentage_coverage

  def current_period
    if self.monthly?
      Date.current.strftime('%Y-%m')
    elsif self.weekly?
      Date.current.strftime('%Y-W%W')
    elsif self.daily?
      Date.current.strftime('%Y-%m-%d')
    elsif self.yearly?
      Date.current.strftime('%Y')
    end
  end

  def period_range(period)
    if self.monthly?
      beginning_of_period = Date.parse("#{period}-01").beginning_of_month
      end_of_period = Date.parse("#{period}-01").end_of_month
    elsif self.weekly?
      Date.strptime(period, '%Y-W%W')
      beginning_of_period = Date.strptime(period, '%Y-W%W').beginning_of_week
      end_of_period = Date.strptime(period, '%Y-W%W').end_of_week
    elsif self.daily?
      beginning_of_period = Date.parse(period).beginning_of_day
      end_of_period = Date.parse(period).end_of_day
    elsif self.yearly?
      beginning_of_period = Date.parse("#{period}-01-01")
      end_of_period = Date.parse("#{period}-12-31")
    end

    return beginning_of_period..end_of_period
  end

  def current_period_message
    if self.monthly?
      "this month"
    elsif self.weekly?
      "this week"
    elsif self.daily?
      "today"
    elsif self.yearly?
      "this year"
    end
  end

  def total_spent(period_range = self.period_range(self.current_period))
    total = Money.from_amount(0, self.family.currency)
    self.expenditures.in_period(period_range).each do |expenditure|
      total += expenditure.amount_as_currency
    end
    total
  end

  def amount_left(period_range = self.period_range(self.current_period))
    self.amount_as_currency - self.total_spent(period_range)
  end

  def total_percentage_spent(period_range = self.period_range(self.current_period))
    (self.total_spent(period_range).to_d / self.amount * 100).to_i
  end

  private

  def presence_of_budget_assignees
    unless budget_assignees.any?
      errors.add(:base, 'At least one budget assignee is required.')
    end
  end

  def assignee_percentage_coverage
    total_percentage = budget_assignees.sum { |assignee| assignee.percentage }

    unless total_percentage == 100
      errors.add(:base, "The sum of percentages must be 100%. it is #{total_percentage}")
    end
  end
end
