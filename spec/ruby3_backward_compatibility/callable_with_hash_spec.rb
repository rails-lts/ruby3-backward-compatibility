module Ruby3BackwardCompatibility
  describe CallableWithHash do
    describe '.callable_with_hash' do
      let(:class_with_basic_keyword_methods) do
        Class.new do
          extend CallableWithHash

          callable_with_hash def keyword_method(regular_arg, keyword_arg:)
            [regular_arg, keyword_arg]
          end

          callable_with_hash def optional_keyword_method(regular_arg, keyword_arg: 'default-keyword-arg')
            [regular_arg, keyword_arg]
          end

          callable_with_hash def optional_keyword_method_with_rest_args(regular_arg, keyword_arg: 'default-keyword-arg', **rest_keyword_args)
            [regular_arg, keyword_arg, rest_keyword_args]
          end
        end
      end

      it 'allows to call the method with keyword args' do
        subject = class_with_basic_keyword_methods.new
        expect(subject.keyword_method('foo', keyword_arg: 'bar')).to eq(['foo', 'bar'])
      end

      it 'allows to call the method with an options hash' do
        subject = class_with_basic_keyword_methods.new
        expect(subject.keyword_method('foo', { keyword_arg: 'bar' })).to eq(['foo', 'bar'])
      end

      it 'allows to call the method with an options hash for optional keyword args' do
        subject = class_with_basic_keyword_methods.new
        expect(subject.optional_keyword_method('foo', { keyword_arg: 'bar' })).to eq(['foo', 'bar'])
      end

      it 'allows to call the method with an options hash for optional keyword args and rest keyword args' do
        subject = class_with_basic_keyword_methods.new
        expect(subject.optional_keyword_method_with_rest_args('foo', { keyword_arg: 'bar', other_arg: 'baz' })).to eq(['foo', 'bar', { other_arg: 'baz' }])
      end

      it 'allows to call the method with a to_hash duck type' do
        duck = Object.new
        def duck.to_hash
          { keyword_arg: 'bar' }
        end
        subject = class_with_basic_keyword_methods.new

        expect(subject.keyword_method('foo', duck)).to eq(['foo', 'bar'])
      end

      it 'can enhance previously defined methods' do
        pristine_class = Class.new do
          def keyword_method(regular_arg, keyword_arg:)
            [regular_arg, keyword_arg]
          end
        end
        pristine_class.class_eval do
          extend CallableWithHash
          callable_with_hash :keyword_method
        end
        subject = pristine_class.new

        expect(subject.keyword_method('foo', { keyword_arg: 'bar' })).to eq(['foo', 'bar'])
      end

      it 'can enhance multiple methods at once' do
        pristine_class = Class.new do
          def keyword_method_1(regular_arg, keyword_arg:)
            [regular_arg, keyword_arg]
          end

          def keyword_method_2(regular_arg, keyword_arg:)
            [regular_arg, keyword_arg]
          end
        end
        pristine_class.class_eval do
          extend CallableWithHash
          callable_with_hash :keyword_method_1, :keyword_method_2
        end
        subject = pristine_class.new

        expect(subject.keyword_method_1('foo', { keyword_arg: 'bar' })).to eq(['foo', 'bar'])
        expect(subject.keyword_method_2('foo', { keyword_arg: 'bar' })).to eq(['foo', 'bar'])
      end

      it 'does not turn a hash into keywords if it is a required argument' do
        subject = class_with_basic_keyword_methods.new

        expect(subject.optional_keyword_method({ hash: 'data' })).to eq([{ hash: 'data' }, 'default-keyword-arg'])
        expect(subject.optional_keyword_method({ hash: 'data', keyword_arg: 'changed' })).to eq([{ hash: 'data', keyword_arg: 'changed' }, 'default-keyword-arg'])
        expect(subject.optional_keyword_method({ hash: 'data', keyword_arg: 'foo' }, keyword_arg: 'given-keyword-arg')).to eq([{ hash: 'data', keyword_arg: 'foo' }, 'given-keyword-arg'])
        expect(subject.optional_keyword_method('foo' => 'bar')).to eq([{ 'foo' => 'bar' }, 'default-keyword-arg'])
      end

      it 'passes through blocks' do
        subject = Class.new do
          extend CallableWithHash

          callable_with_hash def method_with_block(&block)
            block.call
          end
        end.new

        called = false
        subject.method_with_block { called = true }
        expect(called).to eq(true)
      end

      it 'crashes if the method does not exist' do
        expect do
          Class.new do
            extend CallableWithHash

            callable_with_hash :undefined_method
          end
        end.to raise_error(NameError, /'undefined_method' is not defined/)
      end

      it 'can be configured to ignore unknown methods' do
        expect do
          Class.new do
            extend CallableWithHash

            callable_with_hash :undefined_method, ignore_missing: true
          end
        end.not_to raise_error
      end

      it 'returns a single arguments verbatim' do
        result = nil
        Class.new do
          extend CallableWithHash

          def foo
          end

          result = callable_with_hash :foo
        end
        expect(result).to eq(:foo)
      end

      it 'returns multiple arguments as arrays' do
        result = nil
        Class.new do
          extend CallableWithHash

          def foo
          end

          def bar
          end

          result = callable_with_hash :foo, :bar
        end
        expect(result).to eq([:foo, :bar])
      end

      context 'on private methods' do
        let(:class_with_private_keyword_method) do
          Class.new do
            extend CallableWithHash

            private

            callable_with_hash def private_keyword_method(regular_arg, keyword_arg:)
              [regular_arg, keyword_arg]
            end
          end
        end

        it 'works' do
          subject = class_with_private_keyword_method.new
          expect(subject.send(:private_keyword_method, 'foo', keyword_arg: 'bar')).to eq(['foo', 'bar'])
          expect(subject.send(:private_keyword_method, 'foo', { keyword_arg: 'bar' })).to eq(['foo', 'bar'])
        end

        it 'does not make the method public' do
          subject = class_with_private_keyword_method.new
          expect(subject.respond_to?(:private_method)).to eq(false)
          expect(class_with_private_keyword_method.private_instance_methods).to include(:private_keyword_method)
        end
      end

      context 'on protected methods' do
        let(:class_with_protected_keyword_method) do
          Class.new do
            extend CallableWithHash

            protected

            callable_with_hash def protected_keyword_method(regular_arg, keyword_arg:)
              [regular_arg, keyword_arg]
            end
          end
        end

        it 'works' do
          subject = class_with_protected_keyword_method.new
          expect(subject.send(:protected_keyword_method, 'foo', keyword_arg: 'bar')).to eq(['foo', 'bar'])
          expect(subject.send(:protected_keyword_method, 'foo', { keyword_arg: 'bar' })).to eq(['foo', 'bar'])
        end

        it 'does not make the method public' do
          subject = class_with_protected_keyword_method.new
          expect(subject.respond_to?(:protected_method)).to eq(false)
          expect(class_with_protected_keyword_method.protected_instance_methods).to include(:protected_keyword_method)
        end
      end

      context 'prepended methods' do
        let(:wrap_with_positional_hash) do
          Module.new do
            def prepended_keyword_method(regular_arg, options)
              super
            end
          end
        end
        let(:class_with_prepended_keyword_method) do
          prepend_module = wrap_with_positional_hash
          Class.new do
            extend CallableWithHash
            prepend prepend_module

            callable_with_hash def prepended_keyword_method(regular_arg, keyword_arg: 'default-keyword-arg')
              [regular_arg, keyword_arg]
            end
          end
        end

        it 'works' do
          subject = class_with_prepended_keyword_method.new
          expect(subject.prepended_keyword_method('foo', keyword_arg: 'bar')).to eq(['foo', 'bar'])
          expect(subject.prepended_keyword_method('foo', { keyword_arg: 'bar' })).to eq(['foo', 'bar'])
        end
      end

      context 'inheritance' do
        let(:inherited_class) do
          Class.new(class_with_basic_keyword_methods)
        end

        it 'works' do
          subject = inherited_class.new
          expect(subject.keyword_method('foo', keyword_arg: 'bar')).to eq(['foo', 'bar'])
          expect(subject.keyword_method('foo', { keyword_arg: 'bar' })).to eq(['foo', 'bar'])
        end

        it 'warns when #callable_with_hash is called on the wrong class' do
          expect(CallableWithHash).to receive(:warn).with(match(/appears not to be the correct owner/))

          inherited_class.extend Ruby3BackwardCompatibility::CallableWithHash
          inherited_class.callable_with_hash :keyword_method
        end
      end
    end
  end
end
