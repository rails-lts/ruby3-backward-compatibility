## [Unreleased]

- Ruby 3.2+: Add back `Object#=~`

## [1.3.0] - 2024-04-16

- Ruby 3.2+: Add back third argument to Regexp.new, to allow passing "n" to set `Regexp::NOENCODING`.

## [1.2.0] - 2024-04-10

- First release with dedicated suport to Ruby 3.3.
- Added back `File.exists?` and `Dir.exists?` on Ruby 3.2+.
- Added back `Fixnum` as an alias for `Integer`.

## [1.1.1] - 2022-12-01

- Gem no longer requires Ruby 3. It will not do anything when used on Ruby 2.x, but you can add it to your Gemfile if you need that for a Ruby migration strategy. (Thanks to @BigAirJosh)

## [1.1.0] - 2022-12-01

- Change `callable_with_hash` to return a symbol, if called with a singular method.

## [1.0.0] - 2022-12-01

- Now 1.0, adhering to semantic versioning.
- Breaking: Rename `ruby3_keywords` to `callable_with_hash`.

## [0.3.0] - 2022-11-22

- Security fix: `ruby3_backward_compatibility/compatibility/psych` no longer aliases YAML.load to YAML.safe_load.

## [0.2.3] - 2022-11-22

- Add `ignore_missing: true` option for `ruby3_keywords` to not crash on missing methods.
- Fix `ruby3_backward_compatibility/compatibility/i18n` to not crash when used with older I18n versions.

## [0.2.2] - 2022-11-10

- Fix `ruby3_keywords` to pass blocks.

## [0.2.1] - 2022-11-04

- Fix `ruby3_keywords` for prepended methods.

## [0.2.0] - 2022-10-26

- Add `ruby3_backward_compatibility/compatibility/i18n`.

## [0.1.3] - 2022-10-25

- Allow `ruby3_keywords` to work if method is also defined in a prepended module.

## [0.1.2] - 2022-10-25

- `ruby3_keywords` does not change visibility of private or protected methods.

## [0.1.1] - 2022-10-25

- Initial release
