# Description

Simple Middleware for cleaning up possibly bad requests on selected endpoints

# Authors

* Chris Saunders (http://christophersaunders.ca)
* Yagnik Khanna (http://github.com/yagnik)

# Usage

```ruby
routes_and_strategies = {
  '/login' => [SpaceToDashStrategy]
}
use TheMiddleware, routes_and_strategies
```

# Implementation

```ruby
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
```

#Simple config.ru file for sanity check
```ruby
require 'param_sanitizer'

sanitized_routes = {
  '/login' => [SpaceToDashStrategy]
}

app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, [env['PATH_INFO'], env['QUERY_STRING']]] }

middleware = ParamSanitizer::RequestSanitizer.new(app, sanitized_routes)
run middleware
```