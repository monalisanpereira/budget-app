class RemoveIsOwnerFromFamilyMembers < ActiveRecord::Migration[7.0]
  def change
    remove_column :family_members, :is_owner, :boolean
  end
end
