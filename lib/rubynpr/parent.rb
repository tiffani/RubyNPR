
module NPR
  # Parent represents the parent topics to which a story belongs.  Parents have:
  # 
  # * <tt>id</tt> - a unique NPR ID for the Parent
  # * <tt>title</tt> - the title of the parent topic
  # * <tt>link</tt> - a hash containing the API URI for a parent and the normal web URI
  # * <tt>type</tt> - usually a topic, series, or column
  # 
  class Parent < Content
    attr_accessor :id, :type, :title, :link
  
    private
    def new_from_nprml(parent_nprml)
      return nil if parent_nprml.empty?  
      @id, @type = parent_nprml[:id], parent_nprml[:type]
      @title = parent_nprml.at('title').html
      
      link_nprml = parent_nprml.search('link')
      @link = {  :html => link_nprml[0].html,
                 :api  => link_nprml[1].html }
    end
  end
end