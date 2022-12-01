require 'i18n'

module I18n::Base
  extend Ruby3BackwardCompatibility::CallableWithHash

  callable_with_hash :translate, :translate!, :localize, :t, :l, :transliterate, ignore_missing: true
end
