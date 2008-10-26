require File.dirname(__FILE__) + '/test_rubynpr.rb'

class OrganizationFromNPRMLTest < Test::Unit::TestCase
  def test_should_create_organization_with_abbreviation
    org = Organization.new(Hpricot.XML(Fixtures::Organization.org_with_abbreviation).at('organization'))
    assert_equal 'National Public Radio', org.name
    assert_equal '1', org.id
    assert_equal 'NPR', org.abbr
    assert_equal 'http://www.npr.org', org.website
  end
  
  def test_should_create_organization_without_abbreviation
    org = Organization.new(Hpricot.XML(Fixtures::Organization.org_without_abbreviation).at('organization'))
    assert_nil org.abbr
  end
end