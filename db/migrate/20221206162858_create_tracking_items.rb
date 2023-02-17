class CreateTrackingItems < ActiveRecord::Migration[7.0]
  def change
    create_table :tracking_items do |t|
      t.text :name, null: false, index: {unique: true}

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
