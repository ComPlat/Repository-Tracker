class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_enum :users_role, %w[user super admin]

    create_table :users do |t|
      t.text :name, null: false
      t.enum :role, enum_type: "users_role", default: "user", null: false

      t.timestamps
    end
  end
end
