require 'ruby3_backward_compatibility/compatibility/fixnum'

module Ruby3BackwardCompatibility
  describe 'Fixnum' do
    it 'is Integer' do
      expect(defined?(::Fixnum)).to be_truthy
      expect(::Fixnum).to eql(Integer)
    end
  end
end
