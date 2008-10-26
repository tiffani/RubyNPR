require 'test/unit'

$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require File.dirname(__FILE__) + '/fixtures'
require 'rubynpr'
require 'rubygems'
require 'mocha'

class Test::Unit::TestCase
  include NPR
end