class Expenditure < ApplicationRecord
  belongs_to :family
  belongs_to :budget, optional: true
  has_many :expenditure_assignees, dependent: :destroy
  has_many :assignees, through: :expenditure_assignees, source: :user

  accepts_nested_attributes_for :expenditure_assignees, reject_if: proc { |attributes| attributes['percentage'].to_i.zero? }
  
  scope :non_budget, -> { where(budget: nil) }
end
