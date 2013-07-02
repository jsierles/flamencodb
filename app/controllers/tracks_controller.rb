class TracksController < ApplicationController
  
  def index
    Track.all
  end
  
  def show
    @track = Track.find params[:id]
  end
  
end
