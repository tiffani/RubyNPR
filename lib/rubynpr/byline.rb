module NPR
  # Byline represents a listing of the author(s) of an NPR story.  From a byline, you have
  # access to:
  # 
  # * <tt>id</tt> - unique ID of the byline
  # * <tt>name</tt> - the author's name
  # * <tt>person</tt> - the NPR ID of the author
  # * <tt>links</tt> - links to all content from a particular author
  # 
  class Byline < Content
    attr_accessor :id, :name, :person, :links

    private
    def new_from_nprml(byline_nprml)
      return nil if byline_nprml.empty?
      @id = byline_nprml[:id]
      @name, @person = byline_nprml.at('name').html, byline_nprml.at('name')[:personId]
    end
  end
end