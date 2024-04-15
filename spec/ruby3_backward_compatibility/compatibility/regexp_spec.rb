require 'ruby3_backward_compatibility/compatibility/regexp'

# Note that on Ruby < 3.2 this only tests the default behavior, no patch is active.
module Ruby3BackwardCompatibility
  describe Regexp do
    describe '.new' do
      context 'with a third argument' do
        it 'interprets a third argument "n" as Regexp::NOENCODING' do
          regexp = Regexp.new('test', Regexp::EXTENDED, 'n')
          expect(regexp).to eq(/test/xn)
          expect(regexp.options).to eq(Regexp::EXTENDED | Regexp::NOENCODING)
        end

        it 'interprets a third argument "N" as Regexp::NOENCODING' do
          regexp = Regexp.new('test', Regexp::EXTENDED, 'N')
          expect(regexp).to eq(/test/xn)
          expect(regexp.options).to eq(Regexp::EXTENDED | Regexp::NOENCODING)
        end

        it 'ignores other third arguments' do
          regexp = Regexp.new('test', Regexp::EXTENDED, 'foo')
          expect(regexp).to eq(/test/xn)
          expect(regexp.options).to eq(Regexp::EXTENDED)
        end

        it 'treats a string second argument as Regexp::IGNORECASE' do
          regexp = Regexp.new('test', 'foo', 'N')
          expect(regexp).to eq(/test/in)
          expect(regexp.options).to eq(Regexp::IGNORECASE | Regexp::NOENCODING)
        end

        it 'treats a truish second argument as Regexp::IGNORECASE if a third argument is present' do
          regexp = Regexp.new('test', true, 'N')
          expect(regexp).to eq(/test/in)
          expect(regexp.options).to eq(Regexp::IGNORECASE | Regexp::NOENCODING)
        end

        it 'treats a falsish second argument as 0 if a third argument is present' do
          regexp = Regexp.new('test', false, 'N')
          expect(regexp).to eq(/test/n)
          expect(regexp.options).to eq(Regexp::NOENCODING)
        end

        if RUBY_VERSION >= '3.2' && RUBY_VERSION < '3.3'
          it 'can merge a third argument "n" with string flags' do
            regexp = Regexp.new('test', 'mi', 'n')
            expect(regexp.options).to eq(Regexp::IGNORECASE | Regexp::MULTILINE | Regexp::NOENCODING)

            regexp = Regexp.new('test', 'ix', 'n')
            expect(regexp.options).to eq(Regexp::IGNORECASE | Regexp::EXTENDED | Regexp::NOENCODING)
          end
        end

        if RUBY_VERSION >= '3.3'
          it 'treats string flags as truish when merging a third argument "n"' do
            regexp = Regexp.new('test', 'mx', 'n')
            expect(regexp.options).to eq(Regexp::IGNORECASE | Regexp::NOENCODING)
          end
        end
      end

      it 'can still build a Regexp from string and option' do
        regexp = Regexp.new('test', Regexp::IGNORECASE)
        expect(regexp).to eq(/test/i)
        expect(regexp.options).to eq(Regexp::IGNORECASE)
      end

      it 'can still build a Regexp from another Regexp' do
        regexp = Regexp.new(/test/i)
        expect(regexp).to eq(/test/i)
        expect(regexp.options).to eq(Regexp::IGNORECASE)
      end

      it 'can still build a Regexp with a boolean flag' do
        regexp = Regexp.new('test', true)
        expect(regexp).to eq(/test/i)
        expect(regexp.options).to eq(Regexp::IGNORECASE)
      end

      if RUBY_VERSION >= '3.3'
        it 'treats options of the form "mix" as flags' do
          regexp = Regexp.new('test', 'mix')
          expect(regexp).to eq(/test/mix)
        end

        it 'treats options with different chars as trueish' do
          regexp = Regexp.new('test', 'n')
          expect(regexp).to eq(/test/i)
        end

        it 'sets timeout to nil by default' do
          regexp = Regexp.new('test')
          expect(regexp.timeout).to eq(nil)
        end

        it 'can still build a Regexp with a timeout' do
          regexp = Regexp.new('test', timeout: 1)
          expect(regexp).to eq(/test/)
          expect(regexp.timeout).to eq(1)
        end
      end
    end

    if RUBY_VERSION < '3.2'
      it 'is not patched' do
        expect(defined?(Ruby3BackwardCompatibility::RegexpCompatibility)).to eq(nil)
      end
    end

    if RUBY_VERSION > '3.2'
      it 'is patched' do
        expect(Regexp < Ruby3BackwardCompatibility::RegexpCompatibility).to eq(true)
      end
    end
  end
end
