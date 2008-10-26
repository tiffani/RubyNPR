module NPR
  class PullQuote < Content
    attr_accessor :id, :text, :person, :date
    
    private
    def new_from_nprml(pullquote_nprml)
      return nil if pullquote_nprml.empty?
      @id, @person = pullquote_nprml[:id], pullquote_nprml.at('person').html
      @text = Hpricot.XML(pullquote_nprml.at('text').html).innerText
    end
  end
end