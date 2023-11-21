class FamilyMember < ApplicationRecord
    belongs_to :user
    belongs_to :family

    enum :role, [ :owner, :admin, :editor, :viewer ]
end
