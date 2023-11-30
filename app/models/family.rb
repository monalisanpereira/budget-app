class Family < ApplicationRecord
  has_many :family_members, dependent: :destroy
  has_many :members, through: :family_members, source: :user
  has_many :expenditures, dependent: :destroy
  has_many :budgets, dependent: :destroy
  # has_one :owner, class_name: "User", through: :family_members

  validates :family_name, presence: true

  def member_is_above_admin?(user)
    self.family_members.above_admin.each do |member|
      return true if member.user == user
    end
    false
  end

  def member_is_above_editor?(user)
    self.family_members.above_editor.each do |member|
      return true if member.user == user
    end
    false
  end

  def owner
    self.family_members.owner.user
  end
end
