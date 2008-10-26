require File.dirname(__FILE__) + '/test_rubynpr.rb'

class ImageFromNPRMLTest < Test::Unit::TestCase
  def test_should_create_image
    image = Image.new(Hpricot.XML(Fixtures::Image.typical_image).at('image'))
    assert_equal '92343313', image.id
    assert_equal 'standard', image.type
    assert_equal 'Summer Books Main Page', image.title
    assert_equal 'http://media.npr.org/books/summer/2008/promo_165X40.jpg', image.source
    assert_equal '', image.caption
    assert_equal '', image.producer
    assert_equal '', image.copyright
    assert_equal 'false', image.border
    assert_equal 'http://www.npr.org/templates/story/story.php?storyId=90589316', image.link
  end
end