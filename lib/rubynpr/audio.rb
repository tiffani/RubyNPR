module NPR
  #
  # Audio represents all the available audio that is packaged with a particular story.  Audio
  # features the following attributes: 
  # * <tt>id</tt>: the unique ID for the audio
  # * <tt>duration</tt>: the duration in seconds of the audio
  # * <tt>title</tt>: the title of the audio piece
  # * <tt>formats</tt>: audio pieces come in three different formats: MP3, Windows Media, and Real Audio. Audio
  #   of the different formats can be accessed by a hash like so: <tt>audio.formats[:mp3]</tt>. Hash options are
  #   <tt>:mp3</tt>, <tt>:wm</tt>, <tt>:rm</tt>, and <tt>:ram</tt>. <tt>:ram</tt> is more likely to show up with older stories.
  # 
  class Audio < Content
    FORMATS = [:mp3, :wm, :rm, :ram]
    
    attr_accessor :id, :duration, :type, :title, :formats, :rights_holder, :mp3_rights
     
    private
    def new_from_nprml(audio_nprml)
      return nil if audio_nprml.nil?
      
      @id, @type = audio_nprml[:id], audio_nprml[:type]
      @title, @duration = audio_nprml.at('title').html, audio_nprml.at('duration').html
      @rights_holder = audio_nprml.at('rightsHolder').html
      
      process_audio_formats(audio_nprml.at('format'))
      
      if audio_nprml.at('mp3')
        @mp3_rights = audio_nprml.at('mp3')[:rights]
      end
    end
    
    def process_audio_formats(format_nprml)
      return nil if format_nprml.empty?
      
      @formats = {}
      FORMATS.each do |format|
        unless format_nprml.at(format.to_s).nil?
          @formats[format] = format_nprml.at(format.to_s).html
        end
      end
    end
  end
end