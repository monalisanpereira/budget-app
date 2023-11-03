class Expenditure < ApplicationRecord
    belongs_to :family
    belongs_to :budget, optional: true
    has_many :expenditure_assignees
    has_many :assignees, through: :expenditure_assignees, source: :user
end
