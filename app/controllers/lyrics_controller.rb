class LyricsController < ApplicationController
  def index
    @lyrics = Lyric.completed.order(:body).page(params[:page]).per(50)
  end
  
  def show
    @lyric = Lyric.find params[:id]
  end
end
