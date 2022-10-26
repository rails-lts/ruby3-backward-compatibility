require 'ruby3_backward_compatibility/compatibility/i18n'

I18n.available_locales = [:en]
I18n.locale = :en
I18n.backend.store_translations(:en, {
  foo: {
    bar: 'foobar',
  },
  time: {
    formats: {
      default: '%H:%M',
    },
  },
})

module Ruby3BackwardCompatibility
  describe I18n do
    describe '#translate' do
      it 'can be called a options hash' do
        expect(I18n.translate('bar', { scope: 'foo' })).to eq('foobar')
      end

      it 'can be called with keyword arguments' do
        expect(I18n.translate('bar', scope: 'foo')).to eq('foobar')
      end
    end

    describe '#t' do
      it 'can be called a options hash' do
        expect(I18n.t('bar', { scope: 'foo' })).to eq('foobar')
      end
    end

    describe '#localize' do
      it 'can be called a options hash' do
        expect(I18n.localize(Time.new(2022, 1, 1, 12), { locale: 'en' })).to eq('12:00')
      end
    end

    describe '#l' do
      it 'can be called a options hash' do
        expect(I18n.l(Time.new(2022, 1, 1, 12), { locale: 'en' })).to eq('12:00')
      end
    end

    describe '#transliterate' do
      it 'can be called a options hash' do
        expect(I18n.transliterate('ä', { locale: 'en' })).to eq('a')
      end
    end
  end
end
