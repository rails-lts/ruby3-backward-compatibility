describe 'behavior on Ruby 2' do
  it 'does nothing' do
    expect(defined?(Ruby3BackwardCompatibility::CallableWithHash)).to eq(nil)
  end
end
