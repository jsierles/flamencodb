class Lyric < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include ActiveSupport::Inflector
  
  has_many :tracks, through: :lyric_occurences, :select => 'tracks.*, lyric_occurences.position'
  has_many :lyric_occurences
  
  def has_audio?
    tracks.any? {|t| t.has_audio? }
  end
  
  def self.random
    order("RANDOM()").limit(1).first
  end
  
end
