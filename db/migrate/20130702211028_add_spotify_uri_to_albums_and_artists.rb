class AddSpotifyUriToAlbumsAndArtists < ActiveRecord::Migration
  def change
    add_column :albums, :spotify_uri, :string
    add_column :artists, :spotify_uri, :string
  end
end
