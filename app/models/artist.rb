class Artist < ActiveRecord::Base
  has_many :tracks, through: :track_participations
  has_many :track_participations
end
