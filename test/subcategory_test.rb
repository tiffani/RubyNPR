require File.dirname(__FILE__) + '/test_rubynpr.rb'

class SubcategoryFromNPRMLTest < Test::Unit::TestCase
  def test_should_create_subcategory_with_one_item
    subcategory = Subcategory.new(Hpricot.XML(Fixtures::Subcategory.with_one_item).at('subcategory'))
    assert_equal 1, subcategory.items.length
    assert_equal 'Politics & Society', subcategory.name
  end
  
  def test_should_create_subcategory_with_multiple_items
    subcategory = Subcategory.new(Hpricot.XML(Fixtures::Subcategory.with_multiple_items).at('subcategory'))
    assert_equal 6, subcategory.items.length
    assert_equal 'Books', subcategory.name
  end
end