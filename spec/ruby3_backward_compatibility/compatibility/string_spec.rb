require 'ruby3_backward_compatibility/compatibility/string'

module Ruby3BackwardCompatibility
  describe String do
    describe '#encode' do
      it 'can be called with keyword arguments' do
        expect('aäoö'.encode('US-ASCII', undef: :replace, replace: '_')).to eq('a_o_')
      end

      it 'can be called with an options hash' do
        expect('aäoö'.encode('US-ASCII', { undef: :replace, replace: '_' })).to eq('a_o_')
      end
    end
  end
end
