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
  validate  :presence_of_budget_assignees
  validate  :assignee_percentage_coverage

  def amount_left
    result = amount
    self.expenditures.where(date: Date.current.beginning_of_month..Date.current.end_of_month).each do |expenditure|
      result = result - expenditure.amount
    end
    result
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
