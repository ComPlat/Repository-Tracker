class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_enum :users_role, %w[user super admin]

    create_table :users do |t|
      t.text :name, null: false
      t.enum :role, enum_type: "users_role", null: false

      # Devise
      ## Database authenticatable
      t.text :email, null: false, index: {unique: true}
      t.text :encrypted_password, null: false, index: {unique: true}

      ## Recoverable
      t.text :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token, index: {unique: true}
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token, index: {unique: true} # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.timestamps
    end
  end
end
