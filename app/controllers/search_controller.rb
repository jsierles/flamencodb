class SearchController < ApplicationController
  
  def search
    @artists = Artist.basic_search(params[:q])
    @albums = Album.basic_search(params[:q])
    @lyrics = Lyric.basic_search(params[:q]).includes(:lyric_occurences)
    @tracks = Track.basic_search(params[:q])
  end

end
