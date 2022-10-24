module Ruby3BackwardCompatibility
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
  end

  class Ruby3Class
    extend Ruby3Keywords

    ruby3_keywords :keyword_method
    ruby3_keywords :keyword_method_2, :keyword_method_3
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
    end
  end
end
