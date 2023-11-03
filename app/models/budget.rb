class Budget < ApplicationRecord
    belongs_to :family
    has_many :expenditures
    has_many :budget_assignees
    has_many :users, through: :budget_assignees
end
