class PagesController < ApplicationController
  def home
    @lyric = Lyric.random
  end
end
