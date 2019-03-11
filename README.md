# Kuvera::Api

This gem is an official Kuvera API wrapper.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kuvera-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kuvera-api

## Usage

Currently this gem only supports one-time secrets receving through the `at`
command.

```ruby
Kuvera::Api.at('0x78c4e15f8f1f3e43f6950975f97ff7c2858bcc5a')
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CleverLabs/kuvera-api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
