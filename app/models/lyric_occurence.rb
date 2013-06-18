class LyricOccurence < ActiveRecord::Base  
  belongs_to :track
  belongs_to :lyric
end
