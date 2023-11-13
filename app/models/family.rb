class Family < ApplicationRecord
  has_many :family_members, dependent: :destroy
  has_many :members, through: :family_members, source: :user
  has_many :expenditures, dependent: :destroy
  has_many :budgets, dependent: :destroy
  # has_one :owner, class_name: "User", through: :family_members

  validates :family_name, presence: true
end
