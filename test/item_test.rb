require File.dirname(__FILE__) + '/test_rubynpr.rb'

class ItemFromNPRMLTest < Test::Unit::TestCase
  def test_should_create_item_without_slug
    item = Item.new(Hpricot.XML(Fixtures::Item.item_without_slug).at('item'))
    assert_equal '4499275', item.id
    assert_equal '10', item.number
    assert_equal 'column', item.type
    assert_equal '', item.slug
    assert_equal 'Sweetness And Light', item.title
    assert_equal "Frank Deford's weekly commentary on sports appears Wednesdays on NPR.org.", item.additional_info
  end
  
  def test_should_create_item_with_slug
    item = Item.new(Hpricot.XML(Fixtures::Item.item_with_slug).at('item'))
    assert_equal 'NPR People', item.slug
  end
end