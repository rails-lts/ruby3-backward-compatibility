require 'ruby3_backward_compatibility/compatibility/object'

module Ruby3BackwardCompatibility
  describe Object do
    describe '#taint' do
      it 'returns itself' do
        object = Object.new
        expect(object.taint).to eq(object)
      end
    end

    describe '#untaint' do
      it 'returns itself' do
        object = Object.new
        expect(object.untaint).to eq(object)
      end
    end

    describe '#=~' do
      it 'returns nil' do
        object = Object.new
        expect(object =~ object).to eq(nil)
      end
    end
  end
end
