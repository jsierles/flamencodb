class AddGuitarDetailsToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :guitar_fret, :integer
    add_column :tracks, :guitar_key, :string
  end
end
