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

    def method_4(regular_arg, keyword_arg: 'default-kw-arg')
      [regular_arg, keyword_arg]
    end

    def method_5(regular_arg, keyword_arg: 'default-kw-arg', **)
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

    ruby3_keywords :method_4
    ruby3_keywords :method_5

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

      it 'allows to call the method with a to_hash duck type' do
        duck = Object.new
        def duck.to_hash
          { keyword_arg: 'bar' }
        end

        expect(Ruby3Class.new.keyword_method('foo', duck)).to eq(['foo', 'bar'])
      end

      it 'works for methods that could expect a hash as first argument' do
        expect(Ruby3Class.new.method_4({ hash: 'data' })).to eq([{ hash: 'data' }, 'default-kw-arg'])
        expect(Ruby3Class.new.method_4({ hash: 'data', keyword_arg: 'changed' })).to eq([{ hash: 'data', keyword_arg: 'changed' }, 'default-kw-arg'])
        expect(Ruby3Class.new.method_4({ hash: 'data', keyword_arg: 'foo' }, keyword_arg: 'changed')).to eq([{ hash: 'data', keyword_arg: 'foo' }, 'changed'])
        expect(Ruby3Class.new.method_4('foo' => 'bar')).to eq([{ 'foo' => 'bar' }, 'default-kw-arg'])
      end

      it 'method5 works the way it is used in activesupport' do
        array = [1, { keyword_arg: 'changed' }]
        expect(Ruby3Class.new.method_5(*array, {})).to eq([1, 'changed'])
        expect(Ruby3Class.new.method_5(*array)).to eq([1, 'changed'])
        expect(Ruby3Class.new.method_5(1, keyword_arg: 'changed')).to eq([1, 'changed'])
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
