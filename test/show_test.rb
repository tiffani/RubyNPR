require File.dirname(__FILE__) + '/test_rubynpr.rb'

class ShowTest < Test::Unit::TestCase
  def test_should_create_typical_show
    show = Show.new(Hpricot.XML(Fixtures::Show.typical_show))
    assert_equal '5', show.segment
    assert_equal 'Talk of the Nation', show.program[:name]
    assert_equal '5', show.program[:id]
    assert_equal 'TOTN', show.program[:code]
    assert_equal DateTime.new(2008, 10, 10, 15, 39, 19, DateTime.now.offset), show.date
  end
end