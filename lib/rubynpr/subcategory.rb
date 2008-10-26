module NPR
  # Often, Items are returned by name alphabetically. Each letter would correspond to a Subcategory.
  # A Subcategory has:
  # 
  # * <tt>name</tt> - the name of the Subcategory
  # * <tt>items</tt> - the Items that belong to the Subcategory
  # 
  class Subcategory < Content
    attr_accessor :name, :items
    
    private
    def new_from_nprml(subcategory_nprml)
      @name = subcategory_nprml[:name]
      @items = NPR.process_elements('item', subcategory_nprml)
    end
  end
end