require 'i18n'

module I18n
  class << self
    extend Ruby3BackwardCompatibility::Ruby3Keywords

    ruby3_keywords :translate, :translate!, :localize, :t, :l, :transliterate
  end
end
