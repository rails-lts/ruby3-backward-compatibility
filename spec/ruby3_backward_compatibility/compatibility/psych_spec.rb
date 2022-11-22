require 'ruby3_backward_compatibility/compatibility/psych'

module Ruby3BackwardCompatibility
  describe Psych do
    describe '#safe_load' do
      it 'can be called with old style positional arguments' do
        object = { 't' => Time.now, 'k' => :foo }
        expect(Psych.safe_load(object.to_yaml, [Symbol, Time], [:foo])).to eq(object)

        expect do
          Psych.safe_load(object.to_yaml)
        end.to raise_error(Psych::DisallowedClass)
      end

      it 'can be called with keyword arguments' do
        object = { 't' => Time.now, 'k' => :foo }
        expect(Psych.safe_load(object.to_yaml, permitted_classes: [Symbol, Time], permitted_symbols: [:foo])).to eq(object)
      end
    end
  end
end
