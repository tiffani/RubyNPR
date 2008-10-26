module NPR
  class Message
    attr_accessor :body, :message_id, :raw_message
    
    def initialize(message_id, body, raw_message)
      @body, @message_id, @raw_message = body, message_id, raw_message
    end
    
    def to_s
      "#{ self.class } (#{ message_id }): #{ @body }"
    end
  end
  
  class Warning < Message; end
end