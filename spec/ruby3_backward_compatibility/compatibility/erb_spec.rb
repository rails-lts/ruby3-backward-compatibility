require 'ruby3_backward_compatibility/compatibility/erb'

module Ruby3BackwardCompatibility
  describe ERB do
    describe '#new' do
      it 'can be called with old style positional arguments' do
        name = 'world'
        template = ERB.new("Hello <%= name %>\n<% -%>", nil, '-', '_erbout')
        expect(template.result(binding)).to eq("Hello world\n")
      end

      it 'can be called with new keyword arguments' do
        name = 'world'
        template = ERB.new("Hello <%= name %>\n<% -%>", trim_mode: '-')
        expect(template.result(binding)).to eq("Hello world\n")
      end
    end

    describe '#src' do
      let(:template) { ERB.new('Hello <%= name %>') }

      # Ractor.make_shareable deep-freezes, so unlike the contexts below this
      # reaches the frozen path on every erb, including the erb 4.0.4 that this
      # gem's own bundle resolves.
      context 'when the template has been made shareable for Ractors' do
        def ractor_result(ractor)
          # #take was renamed to #value; both spellings exist across Ruby 3.x.
          ractor.respond_to?(:value) ? ractor.value : ractor.take
        end

        before do
          skip 'Ractor is not available' unless defined?(Ractor)
          begin
            Warning[:experimental] = false
          rescue ArgumentError, NoMethodError
            # older Ruby without that warning category
          end
        end

        it 'can still be read in the main Ractor' do
          shared = Ractor.make_shareable(ERB.new('Hello <%= 1 %>'))
          expect(shared.src).not_to be_frozen
        end

        it 'can still be read from another Ractor' do
          shared = Ractor.make_shareable(ERB.new('Hello <%= 1 %>'))
          ractor = Ractor.new(shared) { |erb| erb.src.frozen? ? 'frozen' : 'mutable' }
          expect(ractor_result(ractor)).to eq('mutable')
        end

        it 'still renders' do
          shared = Ractor.make_shareable(ERB.new('Hello <%= 1 %>'))
          expect(shared.result(binding)).to eq('Hello 1')
        end
      end

      # The guarantee, whichever erb is installed.
      it 'is not frozen' do
        expect(template.src).not_to be_frozen
      end

      it 'can be modified in place, as tilt 1.x does while sniffing the encoding' do
        expect { template.src.force_encoding(Encoding::BINARY) }.not_to raise_error
      end

      it 'returns the same object every time, so an in-place change is not lost' do
        expect(template.src).to equal(template.src)

        template.src.force_encoding(Encoding::BINARY)
        expect(template.src.encoding).to eq(Encoding::BINARY)
      end

      it 'still renders' do
        name = 'world'
        expect(template.result(binding)).to eq('Hello world')
      end

      # The case the patch exists for. It has to be set up by hand rather than
      # left to the installed erb: this gem's own bundle resolves erb 4.0.4,
      # which does not freeze #src, so on that erb the examples above pass with
      # or without the patch and prove nothing. Freezing the ivar reproduces
      # exactly what erb 6.0.7 hands back. Deliberately not primed through #src,
      # so the patch's memo is still empty when the example runs.
      context 'when erb freezes the compiled source, as erb 6.0.7 does' do
        before do
          raw = template.instance_variable_get(:@src)
          template.instance_variable_set(:@src, raw.dup.freeze)
        end

        it 'still hands back something mutable' do
          expect(template.src).not_to be_frozen
          expect { template.src.force_encoding(Encoding::BINARY) }.not_to raise_error
        end

        it 'hands back the same copy every time, so an in-place change survives' do
          expect(template.src).to equal(template.src)

          template.src.force_encoding(Encoding::BINARY)
          expect(template.src.encoding).to eq(Encoding::BINARY)
        end

        it 'still renders' do
          name = 'world'
          expect(template.result(binding)).to eq('Hello world')
        end

        context 'and the template itself is frozen, so the copy cannot be memoized' do
          before { template.freeze }

          it 'hands back something mutable instead of raising FrozenError' do
            expect(template.src).not_to be_frozen
            expect { template.src.force_encoding(Encoding::BINARY) }.not_to raise_error
          end

          it 'still renders' do
            name = 'world'
            expect(template.result(binding)).to eq('Hello world')
          end
        end

        it 'notices if the compiled source is replaced after being read once' do
          first = template.src
          expect(first).not_to be_frozen

          template.instance_variable_set(:@src, "# replaced\n_erbout = +''".freeze)

          expect(template.src).not_to be_frozen
          expect(template.src).to include('# replaced')
          expect(template.src).not_to equal(first)
        end
      end
    end
  end
end
