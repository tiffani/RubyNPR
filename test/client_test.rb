require File.dirname(__FILE__) + '/test_rubynpr.rb'

class ClientTest < Test::Unit::TestCase
  def test_should_raise_exception_if_query_attempted_without_api_key
    client = Client.new
    assert_raise(InvalidAPIKey) { client.query(:id => '95604667') }
  end
  
  def test_should_raise_exception_if_NPR_is_having_issues
    client = Client.new(:api_key => 'bogus_api_key')
    Net::HTTP.stubs(:new).returns(mock(:get => ['headers', Fixtures::Client.npr_system_issues]))
    assert_raise(NPRSystemIssues) { client.query(:id => '95604667') }
  end
  
  def test_should_raise_exception_if_bad_api_key_given
    client = Client.new(:api_key => 'bogus_api_key')
    Net::HTTP.stubs(:new).returns(mock(:get => ['headers', Fixtures::Client.bad_api_key]))
    assert_raise(InvalidAPIKey) { client.query(:id => '95604667') }
  end
  
  def test_should_raise_exception_if_deactivated_api_key_given
    client = Client.new(:api_key => 'inactive_api_key')
    Net::HTTP.stubs(:new).returns(mock(:get => ['headers', Fixtures::Client.deactivated_api_key]))
    assert_raise(DeactivatedAPIKey) { client.query(:id => '95604667') }
  end
  
  def test_should_raise_exception_if_invalid_list_requested
    client = Client.new(:api_key => 'ridiculous_api_key')
    Net::HTTP.stubs(:new).returns(mock(:get => ['headers', Fixtures::Client.invalid_list]))
    assert_raise(InvalidList) { client.list(:id => '3210') }
  end
  
  def test_should_raise_exception_if_invalid_query_generated
    client = Client.new(:api_key => 'some_api_key_that_works')
    assert_raise(InvalidQueryOptions) { client.query(:start_date => Time.utc(2008, 9, 30)) }
  end
  
  def test_should_create_warnings_from_query
    client = Client.new(:api_key => 'some_api_key_that_works')
    Net::HTTP.stubs(:new).returns(mock(:get => ['headers', Fixtures::Client.results_with_warning]))
    client.query(:id => 1017, :end_date => Time.utc(2015, 12, 31))
    assert_equal 1, client.warnings.size
  end
end