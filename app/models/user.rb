class User < ApplicationRecord
  has_many :family_members, dependent: :destroy
  has_many :families, through: :family_members
  has_many :budget_assignees, dependent: :destroy
  has_many :budgets, through: :budget_assignees
  has_many :expenditure_assignees, dependent: :destroy
  has_many :expenditures, through: :expenditure_assignees

  validates :username, presence: true
  validates :email, presence: true
  validates :password_digest, presence: true

  has_secure_password
end
