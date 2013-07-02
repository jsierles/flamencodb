class Artist < ActiveRecord::Base
  has_many :tracks, through: :track_participations
  has_many :track_participations
  
  def update_spotify_uri
    update_attribute :spotify_uri, spotify_record.try(:uri) if !spotify_uri
  end
  
  def spotify_record
    MetaSpotify::Artist.search(name)[:artists].first
  end
  
  def self.searchable_language
    'spanish'
  end
  
end
