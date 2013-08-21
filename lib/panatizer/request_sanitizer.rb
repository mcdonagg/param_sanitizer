module Panatizer
  class RequestSanitizer
    attr_reader :strategized_routes
    
    def initialize(app, *args)
      @app = app
      @strategized_routes = args.last.is_a?(Hash) ? args.last : {}
      emit_warning if @strategized_routes.empty?
    end
    
    def call(env)
      request = Rack::Request.new(env)
      execute_strategies(request) if has_strategy?(request.path)
      @app.call(env)
    end
    
    def execute_strategies(request)
      strategies = @strategized_routes[request.path]
      strategies.each { |strategy| strategy.call(request)}
    end
    
    def has_strategy?(route)
      @strategized_routes.has_key?(route)
    end
    
    def emit_warning
      puts "Panatizer::RequestSanitizer initialized without sanitization strategies. Middleware is now a no-op"
    end
  end
end