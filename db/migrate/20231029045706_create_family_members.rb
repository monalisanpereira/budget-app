class CreateFamilyMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :family_members do |t|
      t.belongs_to :family, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.boolean :is_owner, null: false, default: false
      t.integer :role
    end
  end
end
