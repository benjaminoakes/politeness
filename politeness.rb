# Require your Ruby code to be more polite:  require 'politeness'
# 
# How this works is somewhat modeled after Dave Thomas' wonderful Ruby metaprogramming screencasts.
# 
# Author: Benjamin Oakes <hello@benjaminoakes.com>

module Politeness 
  $method_call_count = 0.0
  $politeness = 0.0

  def self.included(klass)
    klass.const_set(:METHOD_HASH, {})
    suppress_tracing do 
      klass.instance_methods(false).each do |method|    
        wrap_method(klass, method.to_sym)
      end
    end   

    def klass.method_added(name)    
      return if @_adding_a_method
      @_adding_a_method = true
      Politeness.wrap_method(self, name) 
      @_adding_a_method = false
    end
  end

  def self.suppress_tracing
    Thread.current[:'suppress tracing'] = true
    yield
  ensure
    Thread.current[:'suppress tracing'] = false
  end
  
  def self.wrap_method(klass, name)
    method_hash = klass.const_get(:METHOD_HASH) || fail("No method hash")
    method_hash[name] = klass.instance_method(name)
    klass.class_eval %{
      def #{name}(*args, &block)  
        $method_call_count += 1.0
        
        if 1.0 == ($politeness / $method_call_count) || (0.0 == ($politeness / $method_call_count) && $method_call_count < 5.0)
          return METHOD_HASH[:#{name}].bind(self).call(*args, &block)
        end

        if ($politeness / $method_call_count) < 0.27
          puts
          puts 'Not polite enough!'
          exit
        elsif ($politeness / $method_call_count) > 0.72
          puts
          puts 'Too polite!'
          exit
        else
          return METHOD_HASH[:#{name}].bind(self).call(*args, &block)
        end
      end
     }
  end
end

module Kernel
  def please(*args)
    $politeness += 1
    return *args
  end
end

class Object
  include Politeness
end

