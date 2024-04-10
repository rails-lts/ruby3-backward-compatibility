require 'ruby3_backward_compatibility/compatibility/dir'

module Ruby3BackwardCompatibility
  describe Dir do
    describe '#exists?' do
      it 'works like "exist?"' do
        expect(Dir.exists?(__dir__)).to eq(true)
        expect(Dir.exists?('foobar.baz')).to eq(false)
      end
    end
  end
end
