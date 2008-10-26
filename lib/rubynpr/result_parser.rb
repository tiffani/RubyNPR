require 'rubygems'
require 'hpricot'

module NPR
  class ResultParser
    def parse(raw_results)
      h_raw_results = Hpricot.XML(raw_results) 
      result = transform_nprml(h_raw_results) if h_raw_results.search('nprml')
    end
    
    private
    def transform_nprml(raw_results)
      # handle things according to whether you're dealing with a list of stories or topics
      list = raw_results.at('list')
      raw_results.search('story').empty? ? List.new(list) : StoryList.new(list)
    end
  end
end