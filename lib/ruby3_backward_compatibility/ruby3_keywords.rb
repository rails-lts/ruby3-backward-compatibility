module Ruby3BackwardCompatibility
  module Ruby3Keywords
    def self.extended(by)
      # prepend the anonymous module now, so the user has a chance to control where exactly we will end 
      # up in the prepend chain...
      by.send(:_ruby3_keywords_module)
    end

    def ruby3_keywords(*methods)
      methods.each do |method|
        method_is_private = private_instance_methods.include?(method)
        method_is_protected = protected_instance_methods.include?(method)

        arity_before_prepend = self.instance_method(method).arity
        _ruby3_keywords_module.define_method(method) do |*args, **keyword_args|
          if args.last.respond_to?(:to_hash) && args.size > (arity_before_prepend.abs-1)
            keyword_args.merge!(args.pop)
          end
          super(*args, **keyword_args)
        end

        if method_is_private
          _ruby3_keywords_module.send(:private, method)
        elsif method_is_protected
          _ruby3_keywords_module.send(:protected, method)
        end
      end
    end

    private

    def _ruby3_keywords_module
      @_ruby3_keywords_module ||= begin
        mod = Module.new
        prepend mod
        mod
      end
    end
  end
end
