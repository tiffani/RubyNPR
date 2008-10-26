$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubynpr/content'
require 'rubynpr/audio'
require 'rubynpr/byline'
require 'rubynpr/client'
require 'rubynpr/exception'
require 'rubynpr/image'
require 'rubynpr/item'
require 'rubynpr/list'
require 'rubynpr/message'
require 'rubynpr/organization'
require 'rubynpr/parent'
require 'rubynpr/product'
require 'rubynpr/pull_quote'
require 'rubynpr/related_link'
require 'rubynpr/result_parser'
require 'rubynpr/show'
require 'rubynpr/story'
require 'rubynpr/subcategory'
require 'rubygems'
require 'ruby-debug'
require 'date'

class RubyNPR 
  VERSION = '0.1.0'
end