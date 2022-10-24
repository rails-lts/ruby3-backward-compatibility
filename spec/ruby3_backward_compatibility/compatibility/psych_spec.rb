require 'ruby3_backward_compatibility/compatibility/psych'

module Ruby3BackwardCompatibility
  describe Psych do
    describe '#load' do
      it 'behaves like unsafe_load' do
        unsafe_object = { t: Time.now }
        expect(Psych.load(unsafe_object.to_yaml)).to eq(unsafe_object)
      end
    end

    describe '#safe_load' do
      it 'can be called with old style positional arguments' do
        p Psych::VERSION.class
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
