module ApplicationHelper

  def occurrences_for(lyric)
    lyric.lyric_occurences.collect do |lo|
      "#{link_to lo.track.singer.name, artist_path(lo.track.singer)} por <i>#{lo.track.style}</i> en #{link_to lo.track.title, lo.track} #{audio_for(lo.track)}"  
    end.join("<br />")
  end

  def audio_for(track)
    if track.has_audio?
      "<audio style=\"margin-top: 5px\" controls>
        <source src=\"#{track.audio_url}\" type=\"audio/mpeg\">
      Your browser does not support the audio element.
      </audio>"
    end
  end
end
