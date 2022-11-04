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
      let(:class_with_basic_keyword_methods) do
        Class.new do
          extend Ruby3Keywords

          ruby3_keywords def keyword_method(regular_arg, keyword_arg:)
            [regular_arg, keyword_arg]
          end

          ruby3_keywords def optional_keyword_method(regular_arg, keyword_arg: 'default-keyword-arg')
            [regular_arg, keyword_arg]
          end

          ruby3_keywords def optional_keyword_method_with_rest_args(regular_arg, keyword_arg: 'default-keyword-arg', **rest_keyword_args)
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
          extend Ruby3Keywords
          ruby3_keywords :keyword_method
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
          extend Ruby3Keywords
          ruby3_keywords :keyword_method_1, :keyword_method_2
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

      context 'on private methods' do
        let(:class_with_private_keyword_method) do
          Class.new do
            extend Ruby3Keywords

            private

            ruby3_keywords def private_keyword_method(regular_arg, keyword_arg:)
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
            extend Ruby3Keywords

            protected

            ruby3_keywords def protected_keyword_method(regular_arg, keyword_arg:)
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
            extend Ruby3Keywords
            prepend prepend_module

            ruby3_keywords def prepended_keyword_method(regular_arg, keyword_arg: 'default-keyword-arg')
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
    end
  end
end
