if RUBY_VERSION >= '3.2'
  # on 3.2 exactly, we get deprecation errors
  # however, this is somewhat hard to fix, since 3.2 added some different ways to pass "options" that we do not want to rebuild

  module Ruby3BackwardCompatibility
    module RegexpCompatibility
      LEGITIMATE_FLAGS = /\A[mix]+\z/

      def self.prepended(by)
        by.singleton_class.prepend ClassMethods
      end

      module ClassMethods
        def new(regexp_or_string, options = NOT_GIVEN, n_flag = NOT_GIVEN, **kwargs)
          if options == NOT_GIVEN
            super(regexp_or_string, **kwargs)
          elsif n_flag == 'n' || n_flag == 'N'
            unless options.is_a?(Integer)
              if RUBY_VERSION < '3.3' && options.is_a?(String) && options =~ LEGITIMATE_FLAGS
                # on Ruby 3.2 we can legitimately have options "mix" treated as flags, so parse them
                # on Ruby 3.3 this would never have been legitimate, since a third argument would not have been allowed
                new_options = 0
                new_options |= Regexp::MULTILINE if options.include?('m')
                new_options |= Regexp::IGNORECASE if options.include?('i')
                new_options |= Regexp::EXTENDED if options.include?('x')
                options = new_options
              else
                # on all other Ruby, truish is IGNORECASE
                options = options ? Regexp::IGNORECASE : 0
              end
            end
            super(regexp_or_string, options | Regexp::NOENCODING, **kwargs)
          elsif options.is_a?(String)
            if options =~ LEGITIMATE_FLAGS && n_flag == NOT_GIVEN
              # this (like any trueish value) would have been "ignore case" in Ruby < 3.2, but now is not
              # we have to assume this is Ruby 3.2 syntax
              super(regexp_or_string, options, **kwargs)
            else
              # this crashes on Ruby 3.2, so assume it is < 3.2 syntax
              super(regexp_or_string, true, **kwargs)
            end
          else
            super(regexp_or_string, options, **kwargs)
          end
        end
      end
    end
  end

  Regexp.prepend Ruby3BackwardCompatibility::RegexpCompatibility
end
