require 'ruby3_backward_compatibility/compatibility/file'

module Ruby3BackwardCompatibility
  describe File do
    describe '#exists?' do
      it 'works like "exist?"' do
        expect(File.exists?(__FILE__)).to eq(true)
        expect(File.exists?('foobar.baz')).to eq(false)
      end
    end
  end
end
