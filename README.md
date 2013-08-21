# Panatizer

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'panatizer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install panatizer

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


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
