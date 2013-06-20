module ApplicationHelper

  def occurrences_for(lyric)
    lyric.lyric_occurences.collect do |lo|
      "<i>#{lo.track.palo}</i> de  por  en #{link_to lo.track.title, lo.track}}"
    end.join("<br />")
  end

  def poetic_lyric(lyric)
    lyric.body.gsub("\n", "<br />").html_safe
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
