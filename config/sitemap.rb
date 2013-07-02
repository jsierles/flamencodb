SitemapGenerator::Sitemap.default_host = "http://letrasflamencas.es"
SitemapGenerator::Sitemap.create do
  
  Lyric.find_each do |l|
    add lyric_path(l), :lastmod => l.updated_at
  end
  
  Album.find_each do |a|
    add album_path(a), :lastmod => a.updated_at
  end
  
  Artist.find_each do |a|
    add artist_path(a), :lastmod => a.updated_at
  end

  Track.find_each do |t|
    add track_path(t), :lastmod => t.updated_at
  end

end
