require 'ruby3_backward_compatibility/compatibility/uri'

module Ruby3BackwardCompatibility
  describe URI, min_ruby: '3.1' do
    describe '@@schemes' do
      let(:schemes) { URI.module_eval '@@schemes' }

      it 'is readable' do
        expect(schemes['HTTP']).to eq(URI::HTTP)
      end

      it 'is writable' do
        uri_test_class = Class.new
        expect(URI).to receive(:register_scheme).and_call_original

        schemes['URITEST'] = uri_test_class
        expect(schemes['URITEST']).to eq(uri_test_class)
      end
    end
  end
end
