module Ruby3BackwardCompatibility
  module Ruby3Keywords
    def self.find_owned_instance_method(mod, method_name)
      method = mod.send(:instance_method, method_name)
      while method.owner > mod
        # we found the method in a prepended module
        super_method = method.super_method
        if super_method.nil?
          warn "Called `ruby3_keywords #{method_name.inspect}` on `#{mod}`, which appears not to be the correct owner. Did you mean to call it on `#{method.owner}`?"
          return method
        else
          method = super_method
        end
      end
      method
    end

    def self.extended(by)
      # prepend the anonymous module now, so the user has a chance to control where exactly we will end 
      # up in the prepend chain...
      by.send(:_ruby3_keywords_module)
    end

    def ruby3_keywords(*method_names)
      method_names.each do |method_name|
        method_is_private = private_instance_methods.include?(method_name)
        method_is_protected = protected_instance_methods.include?(method_name)

        required_param_count = Ruby3Keywords.find_owned_instance_method(self, method_name).parameters.sum { |(kind, _name)| kind == :req ? 1 : 0 }
        _ruby3_keywords_module.define_method(method_name) do |*args|
          if args.last.respond_to?(:to_hash) && args.size > required_param_count
            keyword_args = args.pop
            super(*args, **keyword_args)
          else
            super(*args)
          end
        end

        if method_is_private
          _ruby3_keywords_module.send(:private, method_name)
        elsif method_is_protected
          _ruby3_keywords_module.send(:protected, method_name)
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
