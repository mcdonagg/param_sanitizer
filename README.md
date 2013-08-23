## Description

Simple Middleware for cleaning up possibly bad requests on selected endpoints

## Authors

* Chris Saunders (http://christophersaunders.ca)
* Yagnik Khanna (http://github.com/yagnik)

## Installation 
Add this line to your application's Gemfile:

gem 'rack-encoding-validation'

And then execute:

$ bundle

Or install it yourself as:

$ gem install rack-encoding-validation

## Usage in Rails

In `config/application.rb`, add

```ruby
routes_and_strategies = {
  '/login' => [SpaceToDashStrategy]
}
config.middleware.use 'ParamSanitizer::RequestSanitizer', routes_and_strategies
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request