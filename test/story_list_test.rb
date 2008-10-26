require File.dirname(__FILE__) + '/test_rubynpr.rb'

class StoryListFromNPRMLTest < Test::Unit::TestCase
  def test_should_create_story_list_with_three_stories
    stories = StoryList.new(Hpricot.XML(Fixtures::Stories.story_result_listing))
    assert_equal 5, stories.list.length
    assert_equal 'Business', stories.title
    assert_equal '', stories.mini_teaser
    assert_equal 'Find the latest business news with reports on Wall Street, interest rates, banking, companies, and U.S. and world financial markets. Subscribe to the Business Story of the Day podcast.', 
      stories.teaser
  end
  
  def test_should_create_story_list_with_one_story
    stories = StoryList.new(Hpricot.XML(Fixtures::Story.typical_story))
    assert_equal 1, stories.list.length
    assert_equal 'Health &amp; Science', stories.title
    assert_equal 'The latest health and science news.  Updates on medicine, healthy living, nutrition, drugs, diet, and advances in	technology...', 
      stories.teaser
    assert_equal '', stories.mini_teaser
  end
end