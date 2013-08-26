require 'unit/test_helper'

module ParamSanitizer
  
  class RequestSanitizerDouble < RequestSanitizer
    def emit_warning
    end
  end
  
  class Tester < ParamSanitizer::UnitTest
    def initialize
      @val = 0
    end
    def call(request)
      @val += 1
      assert_equal 1, @val
    end
  end

  class RequestSanitizerTest < ParamSanitizer::UnitTest
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

    test "execute_strategies should execute a proc" do
      called = 0
      @strategies["/login"] = [lambda{|request| called += 1}]
      Rack::MockRequest.new(middleware).get('/login')
      assert_equal 1, called
    end

    test "execute_strategies should execute a class" do
      @strategies["/login"] = [Tester]
      Rack::MockRequest.new(middleware).get('/login')
    end

    test "execute_strategies should execute a symbol" do
      @strategies["/login"] = [:SpaceToDash]
      ParamSanitizer::Strategies::SpaceToDashStrategy.any_instance.expects(:call)
      Rack::MockRequest.new(middleware).get('/login')
    end

    test "execute strategies should raise ArgumentError if incorrect type is passed in" do
      @strategies["/login"] = ["SpaceToDash"]
      assert_raises ArgumentError do
        Rack::MockRequest.new(middleware).get('/login')
      end
    end

    def middleware
      RequestSanitizerDouble.new(@app, @strategies)
    end
  end
end