module Panatizer
  module Strategies
    class StripPathStrategy      
      def call(request)
        request.params.each do |key, value|
          request.params[key] = nil if value =~ /\\|\//
        end
      end
    end
  end
end