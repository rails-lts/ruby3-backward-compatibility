module Ruby3BackwardCompatibility
  module WrapWithPositionalHash
    def prepended_method(regular_arg, options = nil)
      super
    end
  end

  class Ruby3Class
    def keyword_method(regular_arg, keyword_arg:)
      [regular_arg, keyword_arg]
    end

    def keyword_method_2(regular_arg, keyword_arg:)
      [regular_arg, keyword_arg]
    end

    def keyword_method_3(regular_arg, keyword_arg:)
      [regular_arg, keyword_arg]
    end

    def prepended_method(regular_arg, keyword_arg:)
      [regular_arg, keyword_arg]
    end

    private

    def private_method(regular_arg, keyword_arg:)
      [regular_arg, keyword_arg]
    end

    protected

    def protected_method(regular_arg, keyword_arg:)
      [regular_arg, keyword_arg]
    end
  end

  class Ruby3Class
    extend Ruby3Keywords
    prepend WrapWithPositionalHash

    ruby3_keywords :keyword_method
    ruby3_keywords :keyword_method_2, :keyword_method_3

    ruby3_keywords :private_method

    ruby3_keywords :prepended_method
  end

  describe Ruby3Keywords do
    describe '.ruby3_keywords' do
      it 'allows to call the method with keyword args' do
        expect(Ruby3Class.new.keyword_method('foo', keyword_arg: 'bar')).to eq(['foo', 'bar'])
      end

      it 'allows to call the method with an options hash' do
        expect(Ruby3Class.new.keyword_method('foo', { keyword_arg: 'bar' })).to eq(['foo', 'bar'])
      end

      it 'can loop' do
        expect(Ruby3Class.new.keyword_method_2('foo', { keyword_arg: 'bar' })).to eq(['foo', 'bar'])
        expect(Ruby3Class.new.keyword_method_3('foo', { keyword_arg: 'bar' })).to eq(['foo', 'bar'])
      end

      context 'on private methods' do
        it 'works' do
          expect(Ruby3Class.new.send(:private_method, 'foo', keyword_arg: 'bar')).to eq(['foo', 'bar'])
        end

        it 'does not make the method public' do
          expect(Ruby3Class.new.respond_to?(:private_method)).to eq(false)
          expect(Ruby3Class.private_instance_methods).to include(:private_method)
        end
      end

      context 'on protected methods' do
        it 'works' do
          expect(Ruby3Class.new.send(:protected_method, 'foo', keyword_arg: 'bar')).to eq(['foo', 'bar'])
        end

        it 'does not make the method public' do
          expect(Ruby3Class.new.respond_to?(:protected_method)).to eq(false)
          expect(Ruby3Class.protected_instance_methods).to include(:protected_method)
        end
      end

      context 'methods that are already prepended' do
        it 'works' do
          expect(Ruby3Class.new.prepended_method('foo', keyword_arg: 'bar')).to eq(['foo', 'bar'])
        end
      end
    end
  end
end
