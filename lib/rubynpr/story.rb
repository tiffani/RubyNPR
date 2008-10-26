
module NPR
  RESULT_DATE_FORMAT = "%a, %d %b %Y %H:%M:%S %z"
  
  # Story represents an NPR story.  ruby-npr gives you the following attributes to work with on a Story object:
  # * <tt>id</tt> - unique NPR identifier for each story
  # * <tt>title</tt> - the title of the story.
  # * <tt>subtitle</tt> - a short description of the story
  # * <tt>bylines</tt> - a listing of the story's author(s)
  # * <tt>teaser</tt> - summary of the story
  # * <tt>mini_teaser</tt> - an even shorter summary of the story
  # * <tt>slug</tt> - the main association for the returned story, be it a topic, series, column or other list from NPR
  # * <tt>organization</tt> - the owner of the story
  # * <tt>story_date</tt> - the date the story was published
  # * <tt>publication_date</tt> - the date the story was initially published to NPR. Also can be accessed by <tt>pub_date</tt>
  # * <tt>last_modified</tt> - the date the story was last modified in any sort of way
  # * <tt>audio</tt> - a story's audio attachment
  # * <tt>show</tt> - which show this story originated from (if there was one)
  # * <tt>parents</tt> - parent topics for this story, i.e. economy, health &amp; science, etc.
  # * <tt>products</tt> - any associated products that are included with the story. Usually books.
  # * <tt>related_links</tt> - links to NPR content related to the given story
  # * <tt>html_text</tt> - returns an array of the paragraphs of the text of the story. Includes all the HTML links
  #   and such as originally included in the body of the story.
  # * <tt>plain_text</tt> - also returns an array of the paragraphs of the text of the story. Does not include any HTML.
  # * <tt>images</tt> - any images associated with a story
  # * <tt>link</tt> - a hash with links to the story. Use <tt>@some_story.link[:html]</tt> to access the web page for the given
  #   Story.  Use <tt>@some_story.link[:api]</tt> to access the API representation of the given Story.
  # 
  class Story < Content
    attr_accessor :id, :title, :teaser, :mini_teaser, :slug, :organization, :story_date, :last_modified,
                  :publication_date, :subtitle, :audio, :show, :parents, :short_title, :keywords, 
                  :priority_keywords, :products, :links, :related_links, :bylines, :html_text, :plain_text,
                  :images, :link
    
    #--
    # b/c I'm just as lazy as the next SuzieQ.
    alias_method :pub_date, :publication_date
    alias_method :org, :organization
           
    private
    def new_from_nprml(story_nprml)
      @id = story_nprml[:id]
      @title = story_nprml.at('title').html if story_nprml.at('title')
      @subtitle = story_nprml.at('subtitle').html if story_nprml.at('subtitle')
      @slug = story_nprml.at('slug').html if story_nprml.at('slug')
      @teaser = Hpricot.XML(story_nprml.at('teaser').html).innerText if story_nprml.at('teaser')
      @mini_teaser = Hpricot.XML(story_nprml.at('miniTeaser').html).innerText if story_nprml.at('miniTeaser')
      @link = { :html => story_nprml.at("link[@type='html']").html,
                :api  => story_nprml.at("link[@type='api']").html }
                
      @publication_date = DateTime.strptime(story_nprml.at('pubDate').html, RESULT_DATE_FORMAT) if story_nprml.at('pubDate')
      @story_date = DateTime.strptime(story_nprml.at('storyDate').html, RESULT_DATE_FORMAT) if story_nprml.at('storyDate')
      @last_modified = DateTime.strptime(story_nprml.at('lastModifiedDate').html, RESULT_DATE_FORMAT) if story_nprml.at('lastModifiedDate')
        
      @organization = Organization.new(story_nprml.at('organization')) if story_nprml.at('organization')
      @show = Show.new(story_nprml.at('show')) if story_nprml.at('show')
      @audio = Audio.new(story_nprml.at('audio')) if story_nprml.at('audio')
      
      process_text(story_nprml.search('text'))
      process_text(story_nprml.search('textWithHtml'), true)
      
      story_nprml.search('image') { |image| process_story_images(image) }
      story_nprml.search('parent') { |parent| process_story_parents(parent) }
      story_nprml.search('byline') { |byline| process_story_bylines(byline) }
      story_nprml.search('product') { |product| process_story_products(product) }
      story_nprml.search('relatedLink') { |link| process_related_links(link) }
    end
   
    def process_text(text_nprml, with_html = false)
      unless text_nprml.empty?
        ivar = with_html ? '@html_text' : '@plain_text'
        instance_variable_set(ivar, [])
        text_nprml.search('paragraph').each do |paragraph|
          instance_variable_get(ivar) << Hpricot.XML(paragraph.html).innerText.strip
        end
      end
    end
    
    def process_related_links(nprml)
      @related_links ||= []
      @related_links << RelatedLink.new(nprml)
    end
      
    def method_missing(method_name, *args)
      return nil unless method_name.to_s =~ /process_story_(bylines|parents|products|images)/
      klass = method_name.to_s.split('_').last 
      instance_variable_set("@#{ klass }", []) if instance_variable_get("@#{ klass }").nil?
      instance_variable_get("@#{ klass }") << NPR.const_get(klass.capitalize.chop).new(args[0])
    end
  end 
end