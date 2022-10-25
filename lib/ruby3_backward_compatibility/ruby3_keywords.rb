module Ruby3BackwardCompatibility
  module Ruby3Keywords
    def ruby3_keywords(*methods)
      methods.each do |method|
        method_is_private = private_instance_methods.include?(method)
        method_is_protected = protected_instance_methods.include?(method)

        _ruby3_keywords_module.define_method(method) do |*args, **keyword_args|
          if args.last.is_a?(Hash)
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
