module NPR
  # Organization represents an owner organization of a story.  Includes:
  # 
  # * <tt>id</tt> - unique ID of the organization to which a story belongs
  # * <tt>name</tt> - the name of the organization
  # * <tt>website</tt> - URL for the organization's website
  # * <tt>abbr</tt> - an organization's NPR abbreviation
  # 
  # ==== Example
  # <tt>some_story.organization.name</tt>
  # 
  class Organization < Content
    attr_accessor :id, :name, :website, :abbr
    
    private
    def new_from_nprml(org_nprml)
      return nil if org_nprml.nil?
      @id, @name = org_nprml[:orgId], org_nprml.at('name').html
      @website, @abbr = org_nprml.at('website').html, org_nprml[:orgAbbr]
    end
  end
end