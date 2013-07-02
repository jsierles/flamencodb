class AddSpotifyOffset < ActiveRecord::Migration
  def change
    add_column :lyric_occurences, :spotify_offset, :integer
  end
end
