class Expenditure < ApplicationRecord
  belongs_to :family
  belongs_to :budget, optional: true
  has_many :expenditure_assignees, dependent: :destroy
  has_many :assignees, through: :expenditure_assignees, source: :user

  accepts_nested_attributes_for :expenditure_assignees, reject_if: proc { |attributes| attributes['percentage'].to_i.zero? }
  
  scope :non_budget, -> { where(budget: nil) }

  validates :amount, presence: true
  validates :date, presence: true
  validate  :presence_of_assignees_or_budget
  validate  :assignee_percentage_coverage

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
end
