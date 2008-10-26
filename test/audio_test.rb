require File.dirname(__FILE__) + '/test_rubynpr.rb'

class AudioFromNPRMLTest < Test::Unit::TestCase
  def test_should_create_audio_without_rightsholder
    audio = Audio.new(Hpricot.XML(Fixtures::Audio.with_no_rightsholder_no_mp3rights).at('audio'))
    assert_equal '95608227', audio.id
    assert_equal '', audio.title
    assert_equal 'primary', audio.type
    assert_equal '748', audio.duration
    assert_equal 'http://api.npr.org/m3u/195608227-30ec0e.m3u&amp;ft=3&amp;f=1007', audio.formats[:mp3]
    assert_equal 'http://www.npr.org/templates/dmg/dmg_wmref_em.php?id=95608227&amp;type=1&amp;mtype=WM&amp;ft=3&amp;f=1007', audio.formats[:wm]
    assert_equal 'http://www.npr.org/templates/dmg/dmg_rpm.rpm?id=95608227&amp;type=1&amp;mtype=RM&amp;ft=3&amp;f=1007', audio.formats[:rm]
  end
  
  def test_should_create_audio_without_formats
    audio = Audio.new(Hpricot.XML(Fixtures::Audio.with_no_formats).at('audio'))
    assert_nil audio.formats
  end
  
  def test_should_create_audio_with_mp3_rights
    audio = Audio.new(Hpricot.XML(Fixtures::Audio.with_mp3_rights).at('audio'))
    assert_equal 'Streaming', audio.mp3_rights
  end
end