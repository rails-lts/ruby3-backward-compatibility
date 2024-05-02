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
      it 'returns nil if called on an arbitrary Object' do
        object = Object.new
        expect(object =~ /asdf/).to be_nil
      end

      it 'outputs a deprecation warning if called on an arbitrary Object' do
        begin
          Warning[:deprecated] = true
          hash = {}
          expect { hash =~ /asdf/ }.to output(/deprecated.*Hash/).to_stderr
        ensure
          Warning[:deprecated] = false
        end
      end

      it 'still works on String' do
        string = '-- asdf --'
        expect(string =~ /asdf/).to eq(3)
      end

      it "doesn't output a deprecation warning if called on a String" do
        begin
          Warning[:deprecated] = true
          string = '-- asdf --'
          expect { string =~ /asdf/ }.not_to output(/deprecated/).to_stderr
        ensure
          Warning[:deprecated] = false
        end
      end
    end
  end
end
