require File.dirname(__FILE__) + '/test_rubynpr.rb'

class StoryFromNPRMLTest < Test::Unit::TestCase
  def test_should_create_story_with_all_fields
    story = Story.new(Hpricot.XML(Fixtures::Story.typical_story).at('story'))
    assert_equal '95604667', story.id
    assert_equal 'Bridging Gap Between Mental, Physical Health Care', story.title
    assert_equal '', story.subtitle
    assert_equal 'Health Care', story.slug
    assert_equal 'Provisions slipped into the economic bail out bill mandate that employers and insurance companies give mental health issues parity with physical health issues...', \
      story.teaser
    assert_equal 'A new law says that insurance companies must give parity to mental and physical health issues.', story.mini_teaser
    assert_equal 'http://api.npr.org/query?id=95604667&amp;apiKey=MDAyMDAzMjg3MDEyMjMwMTgyODA0NWNlMg001', story.link[:api]
    assert_equal 'http://www.npr.org/templates/story/story.php?storyId=95604667&amp;ft=3&amp;f=1007', story.link[:html]
    assert_equal DateTime.new(2008, 10, 10, 13, 20, 0, DateTime.now.offset), story.publication_date
    assert_equal DateTime.new(2008, 10, 10, 10, 0, 0, DateTime.now.offset), story.story_date
    assert_equal DateTime.new(2008, 10, 10, 15, 39, 19, DateTime.now.offset), story.last_modified
    assert_kind_of Organization, story.organization
    assert_kind_of Show, story.show
    assert_kind_of Audio, story.audio
    assert_kind_of Array, story.parents
    assert_kind_of Array, story.products
    assert_kind_of Array, story.related_links
    assert_equal 2, story.plain_text.length
    assert_equal 2, story.html_text.length
  end
  
  def test_should_create_story_with_no_fields
    story = Story.new(Hpricot.XML(Fixtures::Story.with_no_fields).at('story'))
    assert_equal('96105723', story.id)
    assert_equal 'http://www.npr.org/templates/story/story.php?storyId=96105723&amp;ft=3&amp;f=96105723', story.link[:html]
    assert_equal 'http://api.npr.org/query?id=96105723&amp;apiKey=MDAyMDAzMjg3MDEyMjQ1Mjg4OTkxZjcyOQ001', story.link[:api]
    assert_nil story.title
    assert_nil story.slug
    assert_nil story.subtitle
    assert_nil story.teaser
    assert_nil story.mini_teaser
    assert_nil story.publication_date
    assert_nil story.story_date
    assert_nil story.last_modified
    assert_nil story.organization
    assert_nil story.show
    assert_nil story.audio
    assert_nil story.parents
    assert_nil story.products
    assert_nil story.related_links
    assert_nil story.plain_text
    assert_nil story.html_text
  end
end