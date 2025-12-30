# frozen_string_literal: true

if RUBY_VERSION.to_i >= 3
  module Ruby3BackwardCompat(bility
    NOT_GIVEN = Object.new
  end

  require 'ruby3_backward_compatibility/callable_with_hash'
  require 'ruby3_backward_compatibility/version'
end
