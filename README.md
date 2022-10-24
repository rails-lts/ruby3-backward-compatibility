# ruby3-backwards-compatibility

This gem provides a compatibility layer to Ruby 3 projects that still have legacy code written against Ruby 2's stdlib. Only use this if you upgrade to Ruby 3 but still depend on some third-party code that breaks on Ruby 3.

The gem will fix only some (but the most common) incompatibilities.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby3-backward-compatibility'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ruby3-backward-compatibility

## Usage

You need to require the specific backports yourself, see below.

You can also require all included backports using

```
require 'ruby3-backward-compatibility/all'
```


## List of backports

### ruby3 keyword arguments

One breaking change in Ruby 3 is that methods defined using keyword arguments have to be called with keyword arguments, not with option hashes. For example

```
class Ruby3Class
  def some_method(foo:)
    puts foo
  end
end

Ruby3Class.new.some_method(foo: 'bar') # works
Ruby3Class.new.some_method({ foo: 'bar' }) # raises an ArgumentError
```

To fix this for arbitrary methods, you can use the `ruby3_keywords` method included in this gem, like this:

```
require 'ruby3_backward_compatibility'

class Ruby3Class
  # reopen the class

  extend Ruby3BackwardCompatibility::Ruby3Keywords

  ruby3_keywords :some_method
end

Ruby3Class.new.some_method(foo: 'bar') # still works
Ruby3Class.new.some_method({ foo: 'bar' }) # now works as well
```

This will wrap the given method and convert a hash given as the last argument into keywords, similar to how it worked in Ruby 2.

### ERB

`ERB.new` used to have the signature

```
ERB.new(string, safe_level, trim_mode, eoutvar = '_erbout')
```

but this was changed to

```
ERB.new(string, safe_level: nil, trim_mode: nil, eoutvar: '_erbout')
```

To allow both styles, use

```
require 'ruby3_backward_compatibility/compatibility/erb'
```


### Object

The methods `Object#taint` and `Object#untaint` were no-ops for a while but started to raise deprecation warnings.

To add them back as no-ops, use

```
require 'ruby3_backward_compatibility/compatibility/object'
```


### YAML (Psych)

Psych version 4 (default for Ruby 3.1) has two changes:
- `Psych.load` has been renamed to `Psych.unsafe_load`
- The signature of `Psych.safe_load` has been changed from

  ```
  Psych.safe_load(yaml, permitted_classes = [], permitted_symbols = [], aliases = false, filename = nil)
  ```

  to

  ```
  Psych.safe_load(yaml, permitted_classes: [], permitted_symbols: [], aliases: false, filename: nil)
  ```

To alias `Psych.unsafe_load` as `Psych.load`, and to allow both styles of calling `Psych.safe_load`, use

```
require 'ruby3_backward_compatibility/psych'
```

**Attention:** There has been a very good reason why Psych renamed the `.load` method: You may never use `.load` on any external strings. It is possible to create valid YAML strings that lead to the execution of arbitrary code, so calling `YAML.load` on user input is a major security vulnerability.


### String

`String#encode` require keyword arguments. To allow it to be called with an options hash, use

```
require 'ruby3_backward_compatibility/compatibility/string'
```


### URI

The `URI` module allows other libraries to register their own URI schemes. In the past, it was possible to do something like

```
module URI
  @schemes['MYSCHEME'] = MySchemeImplementation
end
```

In Ruby 3, you have to use

```
URI.register_scheme 'MYSCHEME', MySchemeImplementation
```

To add back the old behavior, use

```
require 'ruby3_backward_compatibility/compatibility/uri'
```


## Things we cannot fix

### Proc.new

In Ruby 2, it was possible to use `Proc.new` without giving a block. In this case, the Proc took the block from the current context. A common usecase worked like this:

```
def call_me(block = Proc.new)
  block.call
end

block = proc do
  puts "called"
end

call_me(block) # works
call_me(&block) # also works
call_me { puts "called" } # also works
```

This is no longer possible in Ruby 3 and we are not aware of a way to make a generic port for this.



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
