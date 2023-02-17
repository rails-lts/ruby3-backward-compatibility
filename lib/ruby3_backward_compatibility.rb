# frozen_string_literal: true

if RUBY_VERSION.start_with?('3')
  module Ruby3BackwardCompatibility
    NOT_GIVEN = Object.new

    # TODO private?
  end

  require 'ruby3_backward_compatibility/callable_with_hash'
  require 'ruby3_backward_compatibility/version'
end
