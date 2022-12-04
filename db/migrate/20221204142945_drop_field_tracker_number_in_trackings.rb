class DropFieldTrackerNumberInTrackings < ActiveRecord::Migration[7.0]
  def change
    remove_column :trackings, :tracker_number, type: :text
  end
end
