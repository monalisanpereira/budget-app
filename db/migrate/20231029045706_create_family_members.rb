class CreateFamilyMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :family_members do |t|
      t.belongs_to :family, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.boolean :is_owner, default: false
      t.integer :role
      t.timestamps
    end
  end
end
