class SearchController < ApplicationController
  
  def search
    @lyrics = Lyric.basic_search(params[:q])
  end

end
