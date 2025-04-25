require 'psych'
require 'i18n'
require 'uri'
require 'ruby3_backward_compatibility/compatibility/all'

module Ruby3BackwardCompatibility
  describe 'all' do
    def expand_require(path)
      File.expand_path(File.join(__dir__, '..', '..', '..', '..', 'lib', "#{path}.rb"))
    end

    it 'requires everything' do
      expect($LOADED_FEATURES).to include(expand_require('ruby3_backward_compatibility/compatibility/bignum'))
      expect($LOADED_FEATURES).to include(expand_require('ruby3_backward_compatibility/compatibility/dir'))
      expect($LOADED_FEATURES).to include(expand_require('ruby3_backward_compatibility/compatibility/erb'))
      expect($LOADED_FEATURES).to include(expand_require('ruby3_backward_compatibility/compatibility/file'))
      expect($LOADED_FEATURES).to include(expand_require('ruby3_backward_compatibility/compatibility/fixnum'))
      expect($LOADED_FEATURES).to include(expand_require('ruby3_backward_compatibility/compatibility/i18n'))
      expect($LOADED_FEATURES).to include(expand_require('ruby3_backward_compatibility/compatibility/object'))
      expect($LOADED_FEATURES).to include(expand_require('ruby3_backward_compatibility/compatibility/psych'))
      expect($LOADED_FEATURES).to include(expand_require('ruby3_backward_compatibility/compatibility/regexp'))
      expect($LOADED_FEATURES).to include(expand_require('ruby3_backward_compatibility/compatibility/string'))
      expect($LOADED_FEATURES).to include(expand_require('ruby3_backward_compatibility/compatibility/uri'))
    end
  end
end
