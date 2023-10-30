class Family < ApplicationRecord
    has_many :members, class_name: "User", through: :family_members
    has_one :owner, class_name: "User", through: :family_members
end
