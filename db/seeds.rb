# encoding: utf-8

require 'nokogiri'

dir = __dir__ + "/bottegaflamenca"
files = Dir.new(dir)

files.each do |file|
  next if file == "." || file == ".."
  puts "#{file}\n\n\n\n"
  text = Textractor.text_from_path(dir+"/#{file}")
  file_contents = text.gsub("\v", "").split "\r\n\r\n\r\n"

  if file_contents[1].nil? || file_contents[1].length > 200
    puts file_contents.inspect
  else
    artist, album_title = file_contents[1].split("\r\n")

    if album_title =~ /\(/
      album_title, release_year_txt = album_title.scan(/(.+) \((.*?)\)/).flatten
      if rel_year = release_year_txt.scan(/\d\d\d\d/).first
        release_year = "1-1-#{rel_year}"
      end
    end
    
    if album_title && album_title.is_a?(String)
        
      album = Album.where(title: UnicodeUtils.downcase(album_title.strip).capitalize, release_year: release_year).first_or_create

      if artist =~ /VV/
        album.compilation = true
        album.save
      end
      
      if file_contents[2]
        tracks = file_contents[2].split(/Note Varie.*\r\n\r\n/)
  
        tracks.each do |track_contents|
        
          main_track_contents, track_details = track_contents.split("Archivio Bottega:")
          track_array = main_track_contents.split("\r\n\r\n")
          stripped_title = track_array.shift.gsub("Testo: (?)", "").gsub(/\d/, "").strip

          if stripped_title =~ /\(/
            stripped_array = stripped_title.scan /(.+)\((.*?)\)/
            track_title, track_style = stripped_array.flatten
          else
            track_title = stripped_title
          end
      
          _, artists, track_style_ext, ext_details, capo = track_details.split("\r\n")

          track_artists = artists.split("-").first.split(/,|y\W/)
      
          if capo !=~ /DD/
            fret, key = capo.scan(/Capotasto: (\d) in (.+) -/)
            puts "#{fret}, #{key}"
          end
      
          if !track_style && ext_details =~ /Flamenco /
            track_style = ext_details.scan(/\[(.+)\]/).flatten.first
            puts "STYLE: #{track_style}"
          end
      
          track = Track.where(palo: track_style.try(:strip),
                               title: UnicodeUtils.downcase(track_title.strip).capitalize,
                               album_id: album.id,
                               guitar_fret: fret.try(:strip),
                               guitar_key: key.try(:strip),
                               details: ext_details.try(:strip)).first_or_create
                           
          
          if track_artists
            track_artists.each_with_index do |artist, i|
              next if artist.length < 10

              this_artist = Artist.where(name: artist.strip).first_or_create
              participation_hash = {artist: this_artist, track: track}
          
              if i == 0
                participation_hash[:principal] = true
              end
          
              TrackParticipation.create(participation_hash)          
            end
          end
          
          # left in the track array we have lyrics
      
          track_array.each_with_index do |l, i|
            puts "Lyric: #{l}"
            puts "#{track}"
            lyric = Lyric.where(body: l.strip.gsub("\r","")).first_or_create
            LyricOccurence.create(lyric: lyric, track: track, position: i)
          end
        end # track loop
      end # existing track data
    end # existing album data
  end # existing titles
end

# FLUN import

page = Nokogiri::HTML(File.open(__dir__+"/flun.html"))
tracks = page.css("table[cellpadding='3']")

puts "Importing FLUN #{tracks.size} tracks..."
tracks.each do |t|
    track_values = {}
    lyrics = nil
  
    info_rows = t.css('tr')
    info_rows.each_with_index do |row, i|
    
      row_cells = row.css('td')

      if i == 0
        track_values['artist_name'] = UnicodeUtils.downcase(row_cells.last.css("font").first.text).split.map(&:capitalize).join(' ')
        next
      else
        label = row_cells[0].css("font").first.text.gsub(":", "").strip
        if label == "Letra"
          
          if link = row_cells[1].at("a")
            track_values['audio_url'] = link['href'].gsub("../", "http://flun.cica.es/")
          end
        
          lyrics = row_cells[2].search("p")
        else
          track_values[label] = UnicodeUtils.downcase(row_cells[2].css("font").first.text).capitalize
        end
      end
    
    end
  
    album = Album.where(title: track_values["Nombre del Disco"]).first_or_create do |al|
      al.label = track_values['Casa Discográfica']
      al.release_year = "1-1-#{track_values['Año de Edición']}"
      al.format = track_values['Formato']
      al.matrix = track_values['Número / Matriz']
      al.catalog_number = track_values['Número de Catálogo']
    end
  
    if track_values['Duración']
      minutes, seconds = track_values['Duración'].split(":")
      duration = (minutes.to_i * 60) + seconds.to_i
    else
      duration = nil
    end
  
    track = Track.create(duration: duration, 
                         details: track_values['Observaciones'],
                         palo: track_values['Palo'],
                         style: track_values['Estilo'],
                         title: track_values['Título del Cante'],
                         audio_url: track_values['audio_url'],
                         album: album)
  
      
    main_artist = Artist.where(name: track_values['artist_name']).first_or_create

    p = TrackParticipation.create(artist: main_artist, track: track, role: 'cante')
      
    if track_values['Guitarra']  
      guitarist = Artist.where(name: track_values['Guitarra'].split.map(&:capitalize).join(' ')).first_or_create
      TrackParticipation.create(artist: guitarist, track: track, role: 'guitarra')
    end
  
    if lyrics
      lyrics.each_with_index do |l, i|
        body = l.children.collect do |el|
          el.text.strip.chomp(",").chomp(".").chomp(";") if el.text.length > 2 && el.is_a?(Nokogiri::XML::Text)
        end.compact.join("\n")

        lyric = Lyric.where(body: body).first_or_create
    
        LyricOccurence.create(lyric: lyric, track: track, position: i)
      end
    end
end
puts "Done!"

dir = __dir__ + "/letras_scraped"

Dir.new(dir).each do |file|
  
  next if file == "." || file == ".."
  
  album_title = file.gsub(".txt", "")

  contents = File.read(dir + "/#{file}")
  tracks = contents.split("\n\n\n")

  # remove busted lyrics for now
  tracks.shift if tracks.first =~ /\n\n/

  album = Album.where(title: album_title.strip).first_or_create
  
  while !tracks.empty?
    title_line, lyrics = tracks.shift(2)
    puts title_line
    track_title, track_style, track_artist = title_line.scan(/(.+)\W?\(?(.+)?\)?\W?(.+)?/).flatten
    puts "#{track_title} #{track_style} #{track_artist}"
    track = Track.create(style: track_style,
                         title: track_title,
                         album: album)


    if track_artist
      main_artist = Artist.where(name: track_artist).first_or_create
      p = TrackParticipation.create(artist: main_artist, track: track)
    end

    if lyrics
      lyrics.split("\n\n").each_with_index do |l, i|
        lyric = Lyric.where(body: l.strip).first_or_create
    
        LyricOccurence.create(lyric: lyric, track: track, position: i)
      end
    end
  end
end