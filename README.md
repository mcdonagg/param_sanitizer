# Usage

routes_and_strategies = {
  '/login' => [SpaceToDashStrategy]
}
use TheMiddleware, routes_and_strategies

# Implementation

class TheMiddleware
  def initialize(app, *args)
    if args.last.is_a?(Hash)
      @strategies_for_route = args.last
    end
    @app = app
  end
  
  def call(env)
    request = Rack::Request.new(env)
    execute_strategies(request) if @strategies_for_route.has_key?(request.path)
    @app.call(request.env)
  end
  
  def execute_strategies(request)
    strategies = @strategies_for_route[request.path]
    strategies.each do |strategy|
      strategy.new.call(request)
    end
  end
end
