
module NPR
  # Client handles the connection to NPR.  Create an instance of Client and use Client#query or Client#list to pull
  # content from NPR.
  # 
  class Client
    API_HOST = 'api.npr.org'
    API_OUTPUT_FORMATS = [:nprml, :rss, :media_rss, :json, :html]
    API_INPUT_QUERY_OPTIONS = [:id, :date, :start_date, :end_date, :org_id, :search_term, 
                               :search_type, :num_results, :fields]
    
    attr_accessor :results, :api_key, :warnings
    
    # Creates an NPR API client session.  Set the <tt>:api_key</tt> value to include the NPR API key.  This
    # can also be set later using the <tt>api_key method</tt>.  To get started, make sure you have an API key from NPR. You 
    # can get an API key here: http://www.npr.org/api/index.  Then:
    # 
    # <tt>client = NPR::Client.new(:api_key => 'your NPR api key')</tt>
    # 
    # If a query is attempted using a client whose <tt>api_key</tt> hasn't been set, an InvalidAPIKey exception will be raised.
    # 
    def initialize(options = {})
      @api_key = options[:api_key]
    end
  
    # Sends queries to NPR.  <tt>query</tt> has a bunch of options for building a query.  Options include:
    # * <tt>:id</tt> - returns stories that belong to the given IDs or stories belonging to a given topic ID.  Accepts either a single ID value, 
    #   an array of IDs, or an object representing a topic.
    # * <tt>:date</tt> - returns stories with the exact date requested.  If <tt>:date</tt> to <tt>:current</tt>, one of two things can happen. If
    #   one of the parameters is a program, setting <tt>:date</tt> to <tt>:current</tt> will return stories from the last complete episode of the
    #   given program.  If none of the <tt>:id</tt> parameters is a program, setting <tt>:date</tt> to <tt>:current</tt> will just return stories from today.
    #   <em>Note:</em> Any dates used will be converted to follow the big-endian <tt>YYYY-MM-DD</tt> format as part of the URI as required by NPR
    # * <tt>:start_date</tt> - returns stories published on or after the given date. Takes time as either a UTC or local Time object.
    # * <tt>:end_date</tt> - returns stories published on or before the given date. Same as <tt>:start_date</tt> - takes time as either a 
    #   UTC or local Time object.
    # * <tt>:org_id</tt> - returns stories that are provided by the given organization.
    # * <tt>:search_term</tt> - returns stories that are considered to be matches on the given search term.
    # * <tt>:search_type</tt> - used with <tt>:search_term</tt> to help NPR determine which fields it should search.  If <tt>:search_type</tt> isn't
    #   specified, NPR will search the full content of the story.  Otherwise, use <tt>:main</tt> to search only the <tt>title</tt> and
    #   <tt>teaser</tt> fields on stories.
    # * <tt>:num_results</tt> - determines the number of stories that will be returned.  The NPR API caps the number of stories that can
    #   be returned at 20.  If the <tt>:num_results</tt> is greater than the maximum, the API will return the maximum.
    # * <tt>:start</tt> - used to paginate through a large result set.  Use with <tt>:num_results</tt> to return something lesser than the maximum
    #   number of remaining results (20).
    # * <tt>:fields</tt> - used to specify which attributes to return on stories.  Use a single value or an array of any of the following values:
    #   * <tt>:title</tt>
    #   * <tt>:teaser</tt>
    #   * <tt>:storyDate</tt>
    #   * <tt>:show</tt>
    #   * <tt>:byline</tt>
    #   * <tt>:text</tt>
    #   * <tt>:audio</tt>
    #   * <tt>:image</tt>
    #   * <tt>:textWithHtml</tt>
    #   * <tt>:pullquote</tt>
    #   * <tt>:relatedLink</tt>
    #   * <tt>:album</tt>
    #   * <tt>:product</tt>
    #   * <tt>:parent</tt>
    #   * <tt>:artist</tt> - if the story is about an album, this will return all associated artists
    #   * <tt>:summary</tt> - a way of accessing certain fields including <tt>title</tt>, <tt>subtitle</tt>, <tt>shortTitle</tt>, <tt>teaser</tt>,
    #     <tt>mini_teaser</tt>, <tt>slug</tt>, <tt>thumbnail</tt>, <tt>toenail</tt>, <tt>story_date</tt>, <tt>publication_date</tt>,
    #     <tt>last_modified</tt>, <tt>keywords</tt>, and <tt>priority_keywords</tt>.
    #   * <tt>:titles</tt> - returns all titles associated with a story, e.g., <tt>title</tt>, <tt>subtitle</tt>, <tt>shortTitle</tt>, and <tt>slug</tt>.
    #   * <tt>:teasers</tt> - returns all teasers associated with a story, e.g., <tt>teaser</tt> and <tt>mini_teaser</tt>.
    #   * <tt>:dates</tt> - returns all dates associated with a story, e.g., <tt>story_date</tt>, <tt>publication_date</tt>, and <tt>last_modifed</tt>.
    # 
    # ==== Examples
    # <tt>client.query(:id => 95937183)</tt><br />
    # <tt>client.query(:id => [95937183, 95691841, 95683592])</tt><br />
    # <tt>client.query(:id => 1031, :search_term => 'polio')</tt><br />
    # <tt>client.query(:id => 1017, :search_term => 'Alan Greenspan', :search_type => :main)</tt><br />
    # <tt>client.query(:id => some_topic, :num_results => 3, :start_date => Time.utc(2008, 10, 3))</tt> where <tt>some_topic</tt> is an object
    # representing a topic as pulled from the results of a Client#list query.
    # 
    def query(options = {})
      if @api_key.nil?
        raise InvalidAPIKey.new(NPRException::INVALID_API_KEY, 'An API key has not been specified for this NPR client.')
      elsif !options.include?(:id) && !options.include?(:search_term)
        raise InvalidQueryOptions.new(nil, 'An :id must be specified with every request.')
      end
      
      options.merge!(:type => :query) unless options[:type] == :list
      path = assemble_path(options)
      request(path)
    end

    # Accesses the different kinds of lists available via the NPR API.  NPR provides access to topics, music genres, programs, bios,
    # music artists, columns, and series via the API.  This method takes the lone <tt>:id</tt> hash to specify which list to access.
    # The <tt>:id</tt> parameter only accepts one value.  The available list values to pass with <tt>:id</tt> are 
    # available at http://www.npr.org/api/mappingCodes.php.
    # 
    # The results of these queries are returned as a List where List#list holds Item elements that represent the topics returned.  A query like
    # <tt>all_topics = client.list(:id => '3002')</tt> will return all the topics NPR has.  <tt>some_topic = all_topics.list[3]</tt> is an Item
    # representing a topic. Later, this <tt>some_topic</tt> object can be used to generate queries with Client#query: 
    # <tt>story_results = client.query(:id => some_topic, :num_results => 3)</tt>.
    # 
    # ==== Example
    # <tt>client.list(:id => 3002)</tt>
    # 
    def list(options = {})
      query(options.merge(:type => :list))
    end
  
    private
    def assemble_path(options = {})
      return unless [:list, :query].include?(options[:type])
      path = "/#{ options[:type].to_s }?#{ process_query_options(options) }"
      path += "&format=#{ options[:format] }" if API_OUTPUT_FORMATS.include?(options[:format])
      path += "&apiKey=#{ @api_key }"
    end
    
    def npr_date(date)
      date.strftime("%Y-%m-%d")
    end
    
    def process_query_options(options = {})
      return if options.empty?
      query_string = ""
      options.each do |key, value|
        next unless API_INPUT_QUERY_OPTIONS.include?(key)
        query_string += '&' unless query_string.empty?
        query_string += case key
                      when :id
                        id_s = "id="
                        id_s += if    value.kind_of?(Array): options[:id].join(',')
                                elsif value.kind_of?(Item): value.id
                                else  value.to_s
                                end
                      when :date && options[:date] == :current
                        'date=current'
                      when :start_date
                        "startDate=#{ npr_date(value) }"
                      when :end_date
                        "endDate=#{ npr_date(value) }"
                      when :org_id
                        "orgId=#{ options[:org_id] }"
                      when :search_term
                        "searchTerm=#{ options[:search_term] }"
                      when :search_type
                        "searchType=#{ options[:search_type].to_s }"
                      when :num_results
                        "numResults=#{ value }"
                      when :fields
                        fields = "fields="
                        fields += if   value.kind_of?(Array): options[:fields].join(',')
                                  else value.to_s
                                  end
                      else "#{ key }=#{ value }"
                      end
                    end
      query_string
    end
     
    def process_client_errors(response)
      error_result = Hpricot.XML(response).at("message[@level='error']") || Hpricot.XML(response).at("errorResponse[@error='true']")
      return if error_result.nil?
      
      error_msg = if error_result.at('text')
                    error_result.at('text').html
                  elsif error_result.at('message')
                    error_result.at('message').html
                  end
      
      case error_result[:id]
      when NPRException::SYSTEM_ISSUES
        raise NPRSystemIssues.new(error_result[:id], error_msg)
      when NPRException::INVALID_API_KEY
        raise InvalidAPIKey.new(error_result[:id], error_msg)
      when NPRException::DEACTIVATED_API_KEY
        raise DeactivatedAPIKey.new(error_result[:id], error_msg)
      when nil && error_msg == 'The requested list could not be found.'
        raise InvalidList.new(nil, error_msg)
      end
    end
    
    def process_result_warnings(warning_results)
      return if warning_results.empty?
      @warnings = warning_results.collect { |warning| Warning.new(warning[:id], warning.at('text').html, warning) }
    end
    
    def request(path)
      connection = Net::HTTP.new(API_HOST)
      headers, response = connection.get(path)
        
      process_client_errors(response)
      process_result_warnings(Hpricot.XML(response).search("message[@level='warning']"))
        
      @results = NPR::ResultParser.new.parse(response)
    end
  end
end