class Lyric < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include ActiveSupport::Inflector

  include PgSearch
  multisearchable :against => [:body]
    
  has_many :tracks, -> {select('tracks.*, lyric_occurences.position')}, through: :lyric_occurences
  has_many :lyric_occurences
  
  scope :completed, -> { where("body NOT LIKE '(%'") }

  def has_audio?
    tracks.any? {|t| t.has_audio? }
  end
  
  def self.random
    order("RANDOM()").limit(1).first
  end
  
  def self.searchable_language
    'spanish'
  end
  
end
