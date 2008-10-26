module NPR
  # Topics accessed via the API are packaged as items with the following attributes:
  # 
  # * <tt>id</tt> - the topic ID
  # * <tt>number</tt> - item number
  # * <tt>type</tt> - what kind of content the topic represents, i.e. biography, a column, etc.
  # * <tt>slug</tt> - short item descriptor
  # * <tt>additional_info</tt> - extra info/summary about the target
  # * <tt>title</tt> - the name of the topic
  # 
  class Item < Content
    attr_accessor :id, :number, :type, :slug, :additional_info, :title, :slug
    
    alias_method :info, :additional_info
    
    private
    def new_from_nprml(item_nprml)
      @id, @number = item_nprml[:id], item_nprml[:num]
      @type = item_nprml[:type]
      @slug = item_nprml.at('slug').html
      @title = item_nprml.at('title').html
      @additional_info = item_nprml.at('additionalInfo').html.strip
    end
  end
end