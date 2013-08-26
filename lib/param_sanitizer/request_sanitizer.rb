require 'uri'

module ParamSanitizer
  class RequestSanitizer
    attr_reader :strategized_routes
    
    def initialize(app, *args)
      @app = app
      @strategized_routes = args.last.is_a?(Hash) ? args.last : {}
      emit_warning if @strategized_routes.empty?
    end
    
    def call(env)
      request = Rack::Request.new(env)
      request = execute_strategies(request) if has_strategy?(request.path)
      env["QUERY_STRING"] = encode_to_query_string(request.params)
      @app.call(env)
    end
    
    def execute_strategies(request)
      strategies = @strategized_routes[request.path]
      strategies.each { |strategy|
        instance = build(strategy)
        instance.call(request) if instance.respond_to? :call
      }
      request
    end
    
    def has_strategy?(route)
      @strategized_routes.has_key?(route)
    end
    
    def emit_warning
      puts "ParamSanitizer::RequestSanitizer initialized without sanitization strategies. Middleware is now a no-op"
    end
    
    def encode_to_query_string(params)
      URI.encode(params.map{|k,v| "#{k}=#{v}"}.join('&'))
    end

    def build(strategy)
      if strategy.respond_to?(:call) then strategy
      elsif strategy.respond_to?(:new) then strategy.new
      elsif strategy.is_a?(Symbol) then ParamSanitizer::Strategies.const_get("#{strategy}Strategy").new
      else strategy
      end
    end
  end
end