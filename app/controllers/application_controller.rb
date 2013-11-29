class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter do
    path = request.path == "/" ? "lyrics" : request.path 
    redirect_to "http://tomaflamenco.com/es/#{path}", status: :moved_permanently
  end
    
end
