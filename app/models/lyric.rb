class Lyric < ActiveRecord::Base

  has_many :tracks, through: :lyric_occurences, :select => 'tracks.*, lyric_occurences.position'
  has_many :lyric_occurences
  
  def has_audio?
    tracks.any? {|t| t.has_audio? }
  end
  
end
