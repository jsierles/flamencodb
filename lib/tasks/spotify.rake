namespace :spotify do
  desc "Refresh all spotify URIs for albums, tracks and artists"
  task :refresh => :environment do
    %w(Album Track Artist).each do |c|
      Parallel.each(c.constantize.all, :in_threads => 20) do |i|
        ActiveRecord::Base.connection_pool.with_connection do
          i.update_spotify_uri
        end
      end
    end
  end
end