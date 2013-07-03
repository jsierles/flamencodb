namespace :spotify do
  desc "Refresh all spotify URIs for albums, tracks and artists"
  task :refresh => :environment do
    %w(Album Track Artist).each do |c|
      c.constantize.find_each do |i|
        i.update_spotify_uri
      end
    end
  end
end