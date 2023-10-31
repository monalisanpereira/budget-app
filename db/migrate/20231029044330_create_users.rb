class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, index: { unique: true, name: 'user_username' }
      t.string :password
      t.string :email
      t.timestamps
    end
  end
end
