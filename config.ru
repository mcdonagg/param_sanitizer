require 'param_sanitizer'
sanitized_routes = {
  '/a' => [ParamSanitizer::Strategies::SpaceToDashStrategy],
  '/b' => [ParamSanitizer::Strategies::StripPathStrategy],
  '/c' => [ParamSanitizer::Strategies::StripSchemeStrategy],
  '/a/b' => [ParamSanitizer::Strategies::SpaceToDashStrategy, ParamSanitizer::Strategies::StripPathStrategy],
  '/a/c' => [ParamSanitizer::Strategies::SpaceToDashStrategy, ParamSanitizer::Strategies::StripSchemeStrategy]
}
app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, [env['PATH_INFO'], env['QUERY_STRING']]] }
middleware = ParamSanitizer::RequestSanitizer.new(app, sanitized_routes)
run middleware