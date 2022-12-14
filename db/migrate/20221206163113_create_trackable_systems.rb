class CreateTrackableSystems < ActiveRecord::Migration[7.0]
  def change
    create_table :trackable_systems do |t|
      create_enum :trackable_systems_name,
        %w[radar4kit radar4chem chemotion_repository chemotion_electronic_laboratory_notebook nmrxiv]

      t.enum :name, enum_type: "trackable_systems_name", null: false, index: {unique: true}

      t.timestamps
    end
  end
end
