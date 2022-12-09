class CreateTrackings < ActiveRecord::Migration[7.0]
  def change
    create_enum :trackings_status, %w[draft published submitted reviewing pending accepted reviewed rejected deleted]

    create_table :trackings do |t|
      t.datetime :date_time, null: false
      t.enum :status, enum_type: "trackings_status", default: "draft", null: false
      t.jsonb :metadata, null: false
      t.references :tracking_item, null: false, foreign_key: true
      t.references :from_trackable_system, null: false, foreign_key: {to_table: :trackable_systems}
      t.references :to_trackable_system, null: false, foreign_key: {to_table: :trackable_systems}

      t.timestamps
    end
  end
end
