require 'psych'

module Ruby3BackwardCompatibility
  module PsychCompatibility

    def self.prepended(by)
      by.singleton_class.prepend ClassMethods
    end

    module ClassMethods
      if Psych::VERSION >= '4'
        def load(...)
          unsafe_load(...)
        end
      end

      def safe_load(yaml, legacy_permitted_classes = NOT_GIVEN, legacy_permitted_symbols = NOT_GIVEN, legacy_aliases = NOT_GIVEN, legacy_filename = NOT_GIVEN, permitted_classes: [], permitted_symbols: [], aliases: false, filename: nil, **args)
        if legacy_permitted_classes != NOT_GIVEN
          permitted_classes = legacy_permitted_classes
        end
        if legacy_permitted_symbols != NOT_GIVEN
          permitted_symbols = legacy_permitted_symbols
        end
        if legacy_aliases != NOT_GIVEN
          aliases = legacy_aliases
        end
        if legacy_filename != NOT_GIVEN
          filename = legacy_filename
        end
        super(yaml, permitted_classes: permitted_classes, permitted_symbols: permitted_symbols, aliases: aliases, filename: filename, **args)
      end
    end
  end
end

Psych.prepend Ruby3BackwardCompatibility::PsychCompatibility
