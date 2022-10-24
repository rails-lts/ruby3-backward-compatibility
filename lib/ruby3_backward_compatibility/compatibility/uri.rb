require 'uri'

module Ruby3BackwardCompatibility
  module URICompatibility
    class SchemeProxy
      def [](scheme)
        URI.scheme_list[scheme]
      end

      def []=(scheme, value)
        URI.register_scheme(scheme, value)
      end
    end
  end
end

module URI
  @@schemes ||= Ruby3BackwardCompatibility::URICompatibility::SchemeProxy.new
end
