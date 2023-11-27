class FamilyMember < ApplicationRecord
    belongs_to :user
    belongs_to :family

    enum :role, [ :owner, :admin, :editor, :viewer ]

    scope :owner, -> { where(role: :owner).first }
    scope :admins, -> { where(role: :admin) }
    scope :editors, -> { where(role: :editor) }
    scope :viewers, -> { where(role: :viewer) }
    scope :above_admin, -> { where('role <= ?', roles[:admin]) }
    scope :above_editor, -> { where('role <= ?', roles[:editor]) }
end
