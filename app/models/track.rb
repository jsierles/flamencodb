class Track < ActiveRecord::Base
  belongs_to :album
  has_many :participating_artists, through: :track_participations, source: :artist,
                                   select: "artists.*, principal, role"
  has_many :track_participations
  has_many :lyrics, through: :lyric_occurences,
                    select: 'lyrics.*, position, spotify_offset',
                    order: "position"
                    
  has_many :lyric_occurences
  
  def has_audio?
    audio_url
  end
  
  def derived_title
    return title if title
    style
  end
  
  def principal_artist
    participating_artists.detect {|a| a.principal? }
  end
  
  def complete_style
    txt = ""
    if palo
      txt << palo
    end
    if style
      if palo
        txt << ", "
      end
      txt << style
    end
  end
  
  def update_spotify_uri
    update_attribute :spotify_uri, spotify_record.try(:uri) if !spotify_uri
  end
      
  def spotify_record
    MetaSpotify::Track.search("#{title} #{principal_artist.try(:name)}")[:tracks].first  
  end
  
  def singer
    track_participations.detect {|a| a.role == "cante" }.try :artist
  end
  
  def guitarist
    track_participations.detect {|a| a.role == "guitarra" }.try :artist
  end

  def self.searchable_language
    'spanish'
  end
end
