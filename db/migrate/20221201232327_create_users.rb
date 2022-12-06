class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_enum :user_roles, %w[user super admin]

    create_table :users do |t|
      t.text :name, null: false
      t.enum :role, enum_type: "user_roles", default: "user", null: false

      t.timestamps
    end
  end
end
