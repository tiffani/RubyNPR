require File.dirname(__FILE__) + '/test_rubynpr.rb'

class BylineFromNPRMLTest < Test::Unit::TestCase
  def test_should_create_a_byline
    byline = Byline.new(Hpricot.XML(Fixtures::Byline.typical_byline).at('byline'))
    assert_equal '95703247', byline.id
    assert_equal 'Mara Liasson', byline.name
    assert_equal '1930401', byline.person
  end
end