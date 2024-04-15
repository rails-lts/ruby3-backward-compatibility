require 'ruby3_backward_compatibility'

require 'ruby3_backward_compatibility/compatibility/dir'
require 'ruby3_backward_compatibility/compatibility/erb' if defined?(ERB)
require 'ruby3_backward_compatibility/compatibility/file'
require 'ruby3_backward_compatibility/compatibility/fixnum'
require 'ruby3_backward_compatibility/compatibility/i18n' if defined?(I18n)
require 'ruby3_backward_compatibility/compatibility/object'
require 'ruby3_backward_compatibility/compatibility/psych' if defined?(Psych)
require 'ruby3_backward_compatibility/compatibility/regexp'
require 'ruby3_backward_compatibility/compatibility/string'
require 'ruby3_backward_compatibility/compatibility/uri' if defined?(URI)
