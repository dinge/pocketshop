module ActionController
  class Dispatcher

    def dispatch_cgi(cgi, session_options)
      if cgi ||= self.class.failsafe_response(@output, '400 Bad Request') { CGI.new }
        @request = CgiRequest.new(cgi, session_options)

        @request.env['RAW_POST_DATA'] = nil # resetting this
        @request.env['HTTP_IF_MODIFIED_SINCE'] = nil
        @response = CgiResponse.new(cgi)
        dispatch
      end
    rescue Exception => exception
      failsafe_rescue exception
    end
    
  end
end



