require 'ruby3_backward_compatibility/compatibility/all'

module Ruby3BackwardCompatibility
  describe 'all' do
    it 'requires everything' do
      expect(defined?(Ruby3BackwardCompatibility::ERBCompatibility)).to be_truthy
      expect(defined?(Ruby3BackwardCompatibility::ObjectCompatibility)).to be_truthy
      expect(defined?(Ruby3BackwardCompatibility::PsychCompatibility)).to be_truthy
      expect(::String.is_a?(CallableWithHash)).to eq(true)
      expect(defined?(Ruby3BackwardCompatibility::URICompatibility)).to be_truthy
    end
  end
end
