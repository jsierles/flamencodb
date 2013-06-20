class AddSpotifyLinkToLyricsAndTracks < ActiveRecord::Migration
  def change
    add_column :lyrics, :spotify_offset, :integer
    add_column :tracks, :spotify_uri, :string
  end
end
