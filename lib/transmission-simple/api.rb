module TransmissionSimple
  class Api
    attr :endpoint, true
    attr :session, true
    
    def initialize( endpoint )
      @endpoint = URI.parse(endpoint)
    end
    
    def send_request(request_name, options )
      http = Net::HTTP.new(endpoint.host, endpoint.port) 
      # http.set_debug_output STDOUT
      http.start do |http|
        request = Net::HTTP::Post.new(endpoint.path, {'X-Transmission-Session-Id' => (session or ''), 'Content-Type' => 'application/json' })
        request.body = {:method => request_name}.merge(:arguments => options).to_json
        request.basic_auth *endpoint.userinfo.split(':') if endpoint.userinfo
        
        results = http.request(request)

        if results.code == '409'
          @session = results['x-transmission-session-id']
          return send_request(request_name, options)
        end
        
        json_results = JSON.parse(results.body)
        if json_results['result'] && json_results['result'] == 'success'
          if json_results['arguments']
            if json_results['arguments']['torrents']
              [].tap do |torrents|
                json_results['arguments']['torrents'].each {|t| torrents << Torrent.new(t) }
              end
            else
              json_results['arguments']
            end
          else
            {}
          end
        else
          raise Transmission::Error.new( json_results['result'] )
        end
      end
    end
    
    def method_missing(method, *arguments)
      send_request(transmissionize(method), arguments.shift )
    end
    
    protected
      def transmissionize(method)
        ActiveSupport::Inflector.dasherize(method.to_s.dasherize)
      end
  end
end