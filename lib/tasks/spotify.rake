namespace :spotify do
  desc "Refresh all spotify URIs for albums, tracks and artists"
  task :refresh => :environment do
    %w(Album Track Artist).each do |c|
      c.constantize.find_each do |i|
        puts "Finding #{i.try(:title)} #{i.try(:name)}"
        begin
          i.update_spotify_uri
        rescue
          sleep 1
          puts "Retrying #{i.inspect}"
          retry
        end
      end
    end
  end
end