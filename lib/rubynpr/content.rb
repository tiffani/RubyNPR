module NPR
  # Content is the parent of all the content returned from an NPR query. Mainly in place
  # to assist later in dealing with content returned using different formats.  The intention
  # is to have it become the starting point (obviously with the presence of initialize) for
  # dealing with NPR results in such a way that if somebody was previously dealing with raw
  # JSON for instance, they could throw it over to this and it would return Ruby objects to work
  # with. 'tis forthcoming.
  # 
  class Content
    def initialize(markup, format = :nprml)
      case format
      when :nprml
        new_from_nprml(markup)
      end
    end
  end
end