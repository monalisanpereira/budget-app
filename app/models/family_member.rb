class FamilyMember < ApplicationRecord
    belongs_to :member, class_name: "User"
    belongs_to :family
end
