module TransmissionSimple
  class Torrent < OpenStruct
    def initialize( data = {} )
      super(rubyize(data))
    end
  
    private
      def rubyize( object )
        case object
        when Hash
          {}.tap do |rekeyed|
            object.each_pair {|k,v| rekeyed[ActiveSupport::Inflector.underscore(k)] = ( v.is_a?(Hash) ? OpenStruct.new(rubyize(v)) : rubyize(v) )}          
          end
        when Array
          [].tap do |rubyized|
            object.each {|v| rubyized << (v.is_a?(Hash) ? OpenStruct.new(rubyize(v)) : rubyize(v)) }
          end
        else
          object
        end
      end
  end
end