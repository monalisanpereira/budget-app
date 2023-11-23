class Expenditure < ApplicationRecord
  include MoneyConvertible

  belongs_to :family
  belongs_to :budget, optional: true
  has_many :expenditure_assignees, dependent: :destroy
  has_many :assignees, through: :expenditure_assignees, source: :user

  accepts_nested_attributes_for :expenditure_assignees, reject_if: :invalid_assignee_data?
  
  scope :non_budget, -> { where(budget: nil) }

  validates :amount, presence: true
  validates :date, presence: true
  validate  :presence_of_assignees_or_budget
  validate  :assignee_percentage_coverage

  def amount_as_currency
    Money.from_amount(self.amount, "JPY")
  end

  private

  def presence_of_assignees_or_budget
    if expenditure_assignees.any? && budget.present?
      errors.add(:base, "can't have budget and assignees for the same expense")
    elsif !expenditure_assignees.any? && budget.blank?
      errors.add(:base, "you need to add either a budget or an assignee")
    end
  end

  def assignee_percentage_coverage
    return if budget.present?
    
    total_percentage = expenditure_assignees.sum { |assignee| assignee.percentage }
    unless total_percentage == 100
      errors.add(:base, "The sum of percentages must be 100%. it is #{total_percentage}")
    end
  end

  def invalid_assignee_data?(attributes)
    no_percentage = attributes['percentage'].to_i.zero?
    deleted_assignee = attributes['id'].present? && !ExpenditureAssignee.exists?(id: attributes['id'])

    no_percentage || deleted_assignee
  end
end
