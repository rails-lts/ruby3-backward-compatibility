# frozen_string_literal: true

require 'spec_helper'
require 'ruby3_backward_compatibility/compatibility/bignum'

module Ruby3BackwardCompatibility
  describe Bignum do
    it 'is defined' do
      expect(defined?(Bignum)).to be_truthy
    end

    it 'is an alias for Integer' do
      expect(Bignum).to be(Integer)
    end
  end
end
