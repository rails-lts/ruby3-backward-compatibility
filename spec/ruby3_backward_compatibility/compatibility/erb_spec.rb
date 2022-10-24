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
  end
end
