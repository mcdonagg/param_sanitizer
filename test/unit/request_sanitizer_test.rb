require 'unit/test_helper'

module Panatizer
  
  class RequestSanitizerDouble < RequestSanitizer
    def emit_warning
    end
  end
  
  class RequestSanitizerTest < Panatizer::UnitTest
    def setup
      @app = stub(:call => [200, {}, []])
      @strategies = {
        '/login' => [stub(:call), stub(:call)]
      }
    end
    
    test "strategized_routes have value set is last argument is a hash" do
      assert_equal @strategies, middleware.strategized_routes
    end
    
    test "set strategized_routes to empty hash if hash isn't passed in" do
      middleware = RequestSanitizerDouble.new(@app)
      assert_equal({}, middleware.strategized_routes)
    end
    
    test "it should emit_warning if nothing was passed into the initializer" do
      RequestSanitizerDouble.any_instance.expects(:emit_warning)
      RequestSanitizerDouble.new(@app)
    end
    
    test "has_strategy? should return true if routes match" do
      assert middleware.has_strategy?('/login'), 'The strategies include the path /login and should be passing'
    end
    
    test "execute_strategies should execute a single strategy" do
      @strategies["/login"] = [mock('single-strategy-mock', :call)]
      Rack::MockRequest.new(middleware).get('/login')
    end
    
    test "execute_strategies should execute in order" do
      called = 0
      handler1 = lambda { |request| request['doodle'] = 'called'; called += 1 }
      handler2 = lambda { |request| assert_equal('called', request['doodle']); called += 1 }
      @strategies['/login'] = [handler1, handler2]
      Rack::MockRequest.new(middleware).get('/login')
      assert_equal 2, called
    end
    
    def middleware
      RequestSanitizerDouble.new(@app, @strategies)
    end
  end
end