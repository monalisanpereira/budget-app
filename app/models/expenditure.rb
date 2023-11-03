class Expenditure < ApplicationRecord
    belongs_to :family
    belongs_to :budget
    has_many :expenditure_assignees
    has_many :users, through: :expenditure_assignees
end
