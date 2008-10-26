
module NPR
  # More often than not, a Story was presented as part of an NPR show.  If a Story was
  # presented as part of a show, it can be accessed from a story's <tt>show</tt> attribute.
  # A Show has:
  # 
  # * <tt>program</tt> - a hash with information about the program.  Use <tt>@some_story.show.program[:name]</tt> to
  #   access the name of the show.  <tt>@some_story.show.program[:id]</tt> accesses the ID of the show and 
  #   <tt>@some_story.show.program[:code]</tt> is the NPR abbreviation for the given show
  # * <tt>show_date</tt> - a DateTime object with the date of the show. 
  # * <tt>segment</tt> - the segment of the given show
  # 
  class Show < Content
    attr_accessor :program, :show_date, :segment
    
    PROGRAM_ATTRS = [:id, :code]
    
    alias_method :date, :show_date

    private
    def new_from_nprml(show_nprml)
      return nil if show_nprml.nil?
      @segment = show_nprml.at('segNum').html
      @show_date = DateTime.strptime(show_nprml.at('showDate').html, RESULT_DATE_FORMAT)
      
      prog = show_nprml.at('program')
      @program = { :name => prog.html,
                   :id   => prog[:id],
                   :code => prog[:code] }
    end
  end
end