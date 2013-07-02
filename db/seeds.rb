# encoding: utf-8

require 'nokogiri'

page = Nokogiri::HTML(File.open(File.dirname(__FILE__)+"/flun.html"))   

tracks = page.css("table[cellpadding='3']")

ALBUM_LEGENDS = {
  'Nombre del Disco' => :title,
  'Casa Discográfica' => :label,                     
  'Año de Edición' => :release_year,                 
  'Formato' => :format,                              
  'Número / Matriz' => :matrix_id,                   
  'Número de Catálogo' => :catalog_id,               
  'Etiqueta' => :sticker                             
}

TRACK_LEGENDS = {
  'Palo' => :style,
  'Título del Cante' => :title,
  'Duración' => :duration,
  'Guitarra' => :guitarist,
  'Observaciones' => :details,
  'Letra' => :lyric
}


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

  album = Album.where(title: album_title).first_or_create
  
  while !tracks.empty?
    title_line, lyrics = tracks.shift(2)
    puts title_line
    track_title, track_style, track_artist = title_line.scan(/(.+)\W?\(?(.+)?\)?\W?(.+)?/).flatten
    puts "#{track_title} #{track_style} #{track_artist}"
    track = Track.create(palo: track_style,
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