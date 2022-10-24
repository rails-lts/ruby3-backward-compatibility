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
  end
end

ERB.prepend Ruby3BackwardCompatibility::ERBCompatibility
