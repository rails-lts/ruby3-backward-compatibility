require 'erb'

module Ruby3BackwardCompatibility
  module ERBCompatibility
    def initialize(str, safe_level = NOT_GIVEN, legacy_trim_mode = NOT_GIVEN, legacy_eoutvar = NOT_GIVEN, trim_mode: nil, eoutvar: '_erbout')
      if legacy_trim_mode != NOT_GIVEN
        trim_mode = legacy_trim_mode
      end
      if legacy_eoutvar != NOT_GIVEN
        eoutvar = legacy_eoutvar
      end
      super(str, trim_mode: trim_mode, eoutvar: eoutvar)
    end

    # Newer erb 6 releases freeze the compiled source that #src returns. Every
    # earlier erb handed back a mutable string, and callers written against those
    # are free to modify it in place, e.g. tilt 1.x.
    def src
      original = super
      return original unless original.frozen?

      # A frozen ERB cannot hold the memo, and raising FrozenError here would be
      # a regression: erb itself is happy to return #src from a frozen template,
      # and Ractor.make_shareable deep-freezes, so anything sharing a compiled
      # template across Ractors would break.
      return original.dup if frozen?

      unless @_ruby3_backward_compatibility_src_of.equal?(original)
        @_ruby3_backward_compatibility_src_of = original
        @_ruby3_backward_compatibility_src = original.dup
      end
      @_ruby3_backward_compatibility_src
    end
  end
end

ERB.prepend Ruby3BackwardCompatibility::ERBCompatibility
