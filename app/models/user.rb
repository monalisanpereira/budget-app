class User < ApplicationRecord
  has_many :family_members, dependent: :destroy
  has_many :families, through: :family_members
  has_many :budget_assignees, dependent: :destroy
  has_many :budgets, through: :budget_assignees
  has_many :expenditure_assignees, dependent: :destroy
  has_many :expenditures, through: :expenditure_assignees

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  has_secure_password

  def full_name
    "#{first_name} #{last_name}"
  end
end
