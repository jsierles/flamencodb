class Album < ActiveRecord::Base
  belongs_to :artist
  has_many :tracks
  
  def year
    release_year.try(:year)
  end
  
end
