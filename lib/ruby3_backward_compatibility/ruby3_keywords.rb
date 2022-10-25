module Ruby3BackwardCompatibility
  module Ruby3Keywords
    def ruby3_keywords(*methods)
      methods.each do |method|
        method_object = instance_method(method)

        _ruby3_keywords_module.define_method(method) do |*args, **keyword_args|
          if args.last.is_a?(Hash)
            keyword_args.merge!(args.pop)
          end
          super(*args, **keyword_args)
        end

        if method_object.private?
          _ruby3_keywords_module.send(:private, method)
        elsif method_object.protected?
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
