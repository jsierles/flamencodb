require 'textacular'

class LyricsController < ApplicationController
  def index
    @lyrics = Lyric.all
  end
  
  def show
    @lyric = Lyric.find params[:id]
  end
end
