class Album < ActiveRecord::Base

  belongs_to :artist
  has_many :tracks

  def year
    release_year.try(:year)
  end

  def participating_artists
    tracks.collect {|t| t.participating_artists }.flatten.uniq
  end
  
  def principal_artist
    participating_artists.select {|pa| pa.principal? }.uniq.first
  end
  
  def update_spotify_uri
    update_attribute :spotify_uri, spotify_record.try(:uri) if !spotify_uri
  end
  
  def spotify_record
    MetaSpotify::Album.search("#{title} #{principal_artist.try(:name)}")[:albums].first
  end
  
  def self.searchable_language
    'spanish'
  end
  
end
