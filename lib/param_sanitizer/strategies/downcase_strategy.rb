module ParamSanitizer
  module Strategies
    class DowncaseStrategy      
      def call(request)
        request.params.each do |key, value|
          request.params[key] = value.downcase
        end
      end
    end
  end
end