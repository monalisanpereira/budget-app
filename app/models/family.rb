class Family < ApplicationRecord
    has_many :family_members, dependent: :destroy
    has_many :users, through: :family_members
    has_many :budgets, dependent: :destroy
    has_many :expenditures, dependent: :destroy
    # has_one :owner, class_name: "User", through: :family_members
end
