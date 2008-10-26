module NPR
  class NPRException < StandardError
    SYSTEM_ISSUES = '101'
    INVALID_API_KEY = '310'
    DEACTIVATED_API_KEY = '311' 
    
    attr_accessor :code, :message
    
    def initialize(code, message)
      @code, @message = code, message
    end
    
    def to_s
      "#{ @code }: #{ @message }"
    end
  end
  
  # Raised when NPR is experiencing issues
  class NPRSystemIssues < NPRException; end
  
  # Raised when the API key passed in with the request is invalid
  class InvalidAPIKey < NPRException; end
  
  # Raised when the API key passed in with the request has been deactivated
  class DeactivatedAPIKey < NPRException; end
  
  # Raised when a list is requested that doesn't exist
  class InvalidList < NPRException; end
  
  # Raised when query is not formed with the proper options, i.e. a missing <tt>:id</tt>, etc.
  class InvalidQueryOptions < NPRException; end
end
  
  