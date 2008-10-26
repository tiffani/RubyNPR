module NPR
  # Product represents any products associated with a Story. A lot of stories have
  # books attached as products.  Product isn't officially documented in the NPR API 
  # documentation, thus the comments here are based on observations. Products have the 
  # following attributes:
  # 
  # * <tt>id</tt> - the unique ID for the Product within NPR
  # * <tt>type</tt> - what kind of Product this is, i.e., book, etc
  # * <tt>author</tt> - a book's author
  # * <tt>upc</tt> - the UPC code for a Product
  # * <tt>publisher</tt> - the publisher of a book
  # * <tt>year</tt> - the year the book or Product was introduced/published
  # * <tt>link</tt> - a hash linking to the product for sale on a vendor's website. Use <tt>link[:uri]</tt>
  #  to access the URI for the product and <tt>link[:vendor]</tt> to access the vendor.
  # 
  class Product < Content
    attr_accessor :id, :type, :title, :author, :upc, :publisher, :year, :link
    
    private
    def new_from_nprml(product_nprml)
      @id = product_nprml[:id]
      @type = product_nprml[:type]
      @title = product_nprml.at('title').html
      @author = product_nprml.at('author').html
      @publisher = product_nprml.at('publisher').html
      @year = product_nprml.at('publishYear').html
      @upc = product_nprml.at('upc').html
      @link = { :vendor => product_nprml.at('purchaseLink')[:vendor],
                :uri    => product_nprml.at('purchaseLink').html }
    end
  end
end