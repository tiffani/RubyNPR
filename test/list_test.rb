require File.dirname(__FILE__) + '/test_rubynpr.rb'

class ListFromNPRMLTest < Test::Unit::TestCase
  def test_should_create_list_without_subcategories
    list = TopicList.new(Hpricot.XML(Fixtures::List.without_subcategories).at('list'))
    assert_equal 'All Topics', list.title
    assert_equal '3002', list.type_id
    assert_equal '3002', list.id
    assert_equal false, list.has_subcategories
  end
  
  def test_should_create_list_with_subcategories
    list = TopicList.new(Hpricot.XML(Fixtures::List.with_subcategories).at('list'))
    assert_equal true, list.has_subcategories
    assert_equal 2, list.subcategories.size
  end
end