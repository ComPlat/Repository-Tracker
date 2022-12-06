class CreateTrackableSystems < ActiveRecord::Migration[7.0]
  def change
    create_table :trackable_systems do |t|
      t.text :name, null: false, index: {unique: true}

      t.timestamps
    end
  end
end
