require File.dirname(__FILE__) + '/test_rubynpr.rb'

class RelatedLinksFromNPRMLTest < Test::Unit::TestCase
  def test_should_create_related_link
    rel_link = RelatedLink.new(Hpricot.XML(Fixtures::Relatedlink.typical_link).at('relatedLink'))
    assert_equal 'Bernanke Hints At Rate Cuts', rel_link.caption
    assert_equal 'http://www.npr.org/templates/story/story.php?storyId=95484248&amp;ft=3&amp;f=1006', rel_link.uri[:html]
  end
end