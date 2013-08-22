require 'panatizer'
sanitized_routes = {
  '/a' => [Panatizer::Strategies::SpaceToDashStrategy],
  '/b' => [Panatizer::Strategies::StripPathStrategy],
  '/c' => [Panatizer::Strategies::StripSchemeStrategy],
  '/a/b' => [Panatizer::Strategies::SpaceToDashStrategy, Panatizer::Strategies::StripPathStrategy],
  '/a/c' => [Panatizer::Strategies::SpaceToDashStrategy, Panatizer::Strategies::StripSchemeStrategy]
}
app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, [env['PATH_INFO'], env['QUERY_STRING']]] }
middleware = Panatizer::RequestSanitizer.new(app, sanitized_routes)
run middleware