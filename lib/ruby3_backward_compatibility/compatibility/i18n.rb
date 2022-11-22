require 'i18n'

module I18n::Base
  extend Ruby3BackwardCompatibility::Ruby3Keywords

  ruby3_keywords :translate, :translate!, :localize, :t, :l, :transliterate, ignore_missing: true
end
