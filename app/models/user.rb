class User < ApplicationRecord
    has_many :family_members, dependent: :destroy
    has_many :families, through: :family_members
    has_many :budget_assignees
    has_many :budgets, through: :budget_assignees
    has_many :expenditure_assignees
    has_many :expenditures, through: :expenditure_assignees
end
