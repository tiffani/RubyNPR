module NPR
  class TopicList < Content
    attr_accessor :id, :type_id, :title, :list, :has_subcategories, :subcategories
    
    private
    def new_from_nprml(list_nprml)
      @title = list_nprml.at('title').html
      @id, @type_id = list_nprml[:id], list_nprml[:typeid]
      
      if list_nprml.search('subcategory').empty?
        @has_subcategories = false
        @list = NPR.process_elements('item', list_nprml)
      else
        @has_subcategories = true
        @subcategories = NPR.process_elements('subcategory', list_nprml)
      end
    end
  end
  
  # StoryList contains a listing of all the stories returned for a particular query performed through either
  # NPR::Client#query or NPR::Client#list.
  class StoryList < Content
    attr_accessor :id, :title, :list, :teaser, :mini_teaser
    
    def stories
      @list
    end
    
    private
    def new_from_nprml(story_list_nprml)
      @title = story_list_nprml.at('title').html
      @teaser = Hpricot.XML(story_list_nprml.at('teaser').html).innerText
      @mini_teaser = Hpricot.XML(story_list_nprml.at('miniTeaser').html).innerText
      @list = NPR.process_elements('story', story_list_nprml)
    end
  end
  
  # I REALLY want to move this into Content.
  def self.process_elements(element, nprml)
    return nil if !['story', 'item', 'subcategory'].include?(element)
    list = []
    nprml.search(element).each do |e|
      list << NPR.const_get(element.capitalize).new(e)
    end
    list
  end
end