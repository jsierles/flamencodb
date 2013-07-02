class AddFkIndices < ActiveRecord::Migration
  def change
    add_index :lyric_occurences, [:lyric_id, :track_id]
    add_index :track_participations, [:artist_id, :track_id]
    add_index :tracks, :album_id
  end
end
