module ParamSanitizer
  module Strategies
    class SpaceToDashStrategy      
      def call(request)
        request.params.each do |key, value|
          request.params[key] = value.strip.gsub(' ', '-') if value
        end
      end
    end
  end
end