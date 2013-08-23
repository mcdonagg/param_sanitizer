module ParamSanitizer
  module Strategies
    class StripSchemeStrategy      
      def call(request)
        request.params.each do |key, value|
          request.params[key] = value.gsub(/\A(\w*)\:\/\//, '')
        end
      end
    end
  end
end