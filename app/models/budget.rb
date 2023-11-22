class Budget < ApplicationRecord
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

  def current_period_range
    if self.monthly?
      beginning_of_period = Date.current.beginning_of_month
      end_of_period = Date.current.end_of_month
    elsif self.weekly?
      beginning_of_period = Date.current.beginning_of_week
      end_of_period = Date.current.end_of_week
    elsif self.daily?
      beginning_of_period = Date.current.beginning_of_day
      end_of_period = Date.current.end_of_day
    elsif self.yearly?
      beginning_of_period = Date.current.beginning_of_year
      end_of_period = Date.current.end_of_year
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

  def total_spent
    total = 0
    self.expenditures.where(date: self.current_period_range).each do |expenditure|
      total += expenditure.amount
    end
    total.to_i
  end

  def amount_left
    (self.amount - self.total_spent).to_i
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
