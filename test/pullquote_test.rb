require File.dirname(__FILE__) + '/test_rubynpr.rb'

class PullQuoteFromNPRMLTest < Test::Unit::TestCase
  def test_should_create_pullquote
    pullquote = PullQuote.new(Hpricot.XML(Fixtures::Pullquote.typical_pullquote).at('pullQuote'))
    assert_equal '95611389', pullquote.id
    assert_equal 'Robert Stone', pullquote.person
    assert_equal 'Both [McCain and Obama] in their way are tough guys, and their code is inherent in Robert Jordan. ... Hemingway kind of created the idea of the anti-fascist hero.', 
      pullquote.text
  end
end