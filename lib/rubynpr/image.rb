module NPR
  # Some NPR stories include images.  Images have as attributes:
  # 
  # * <tt>id<tt> - a unique NPR identifier
  # * <tt>type</tt> - TBD
  # * <tt>caption</tt>
  # * <tt>width</tt> - the width of the image in pixels
  # * <tt>src</tt> - the source URL for the image
  # * <tt>border</tt> - indicates if an image has a border
  # * <tt>title</tt>
  # * <tt>link</tt> - the URL to which the image links
  # * <tt>producer</tt> - source who will receive credit for the image
  # * <tt>provider</tt> - the owner or provider of the image, which may be independent of the producer
  # * <tt>copyright</tt> - copyright year
  # 
  class Image < Content
    attr_accessor :id, :type, :width, :src, :border, :title, :link, :producer,
                  :copyright, :caption, :provider
    
    alias_method :source, :src
    
    private
    def new_from_nprml(image_nprml)
      @id, @type = image_nprml[:id], image_nprml[:type]
      @title = image_nprml.at('title').html
      @src = image_nprml[:src]
      @caption = image_nprml.at('caption').html
      @producer = image_nprml.at('producer').html
      @copyright = image_nprml.at('copyright').html
      @border = image_nprml[:hasBorder]
      @link = image_nprml.at('link')[:url]
    end
  end
end