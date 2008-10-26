require File.dirname(__FILE__) + '/test_rubynpr.rb'

class ParentFromNPRMLTest < Test::Unit::TestCase  
  def test_should_create_parent
    parent = Parent.new(Hpricot.XML(Fixtures::Parent.typical_parent).at('parent'))
    assert_equal '1027', parent.id
    assert_equal 'primaryTopic', parent.type
    assert_equal 'Health Care', parent.title
    assert_kind_of Hash, parent.link
    assert_equal 'http://api.npr.org/query?id=1027&amp;apiKey=MDAyMDAzMjg3MDEyMjMwMTgyODA0NWNlMg001', parent.link[:api]
    assert_equal 'http://www.npr.org/templates/topics/topic.php?topicId=1027&amp;ft=3&amp;f=1007', parent.link[:html]
  end
end