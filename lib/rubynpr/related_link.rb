module NPR
  # RelatedLink represents any of the links that are included with an NPR story linking
  # to related NPR content. A RelatedLink has its respective caption and two URIs associated
  # with it: one which returns HTML and one which is the API URI for a story.
  # 
  # * <tt>caption</tt> - caption for a related link
  # * <tt>uri</tt> - a hash containing URIs to access both the HTML and API representations
  #   of a related story. Use options <tt>:html</tt> or <tt>:api</tt>.
  # 
  # ==== Example
  # <tt>@related_link = some_story.related_links[0].uri[:api]</tt>
  # 
  class RelatedLink < Content
    attr_accessor :caption, :uri
    
    private
    def new_from_nprml(rel_link_nprml)
      @caption = Hpricot.XML(rel_link_nprml.at('caption').html).innerText
      uri = rel_link_nprml.search('link')

      @uri = {}
      @uri[:html] = uri[0].html unless uri[0].nil?
      @uri[:api]  = uri[1].html unless uri[1].nil?
    end
  end
end