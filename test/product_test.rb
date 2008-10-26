require File.dirname(__FILE__) + '/test_rubynpr.rb'

class ProductFromNPRMLTest < Test::Unit::TestCase
  def test_should_create_product_as_book
    product = Product.new(Hpricot.XML(Fixtures::Product.book).at('product'))
    assert_equal '94639520', product.id
    assert_equal 'Book', product.type
    assert_equal 'Ordinary People', product.title
    assert_equal 'Judith Guest', product.author
    assert_equal '', product.publisher
    assert_equal '0', product.year
    assert_equal '0140065172', product.upc
    assert_equal 'Amazon', product.link[:vendor]
    assert_equal 'http://www.amazon.com/exec/obidos/ASIN/0140065172/npr-5-20', product.link[:uri]
  end
end