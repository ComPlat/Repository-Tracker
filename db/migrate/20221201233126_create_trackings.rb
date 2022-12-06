class CreateTrackings < ActiveRecord::Migration[7.0]
  def change
    create_enum :tracking_status, %w[draft published submitted reviewing pending accepted reviewed rejected deleted]

    create_table :trackings do |t|
      t.text :from
      t.text :to
      t.datetime :date_time
      t.enum :status, enum_type: "tracking_status", default: "draft", null: false
      t.text :tracker_number
      t.jsonb :metadata
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
