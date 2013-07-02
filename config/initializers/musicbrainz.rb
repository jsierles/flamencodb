MusicBrainz.configure do |c|
  # Application identity (required)
  c.app_name = "Letras Flamencas"
  c.app_version = "1.0"
  c.contact = "joshua@diluvia.net"

  # Cache config (optional)
  c.cache_path = "/tmp/musicbrainz-cache"
  c.perform_caching = true

  # Querying config (optional)
  c.query_interval = 1.2 # seconds
  c.tries_limit = 2
end
