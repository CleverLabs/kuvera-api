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

- One-time secrets receving through the `at` command.

```ruby
Kuvera::Api.at('SHARE-78c4e15f8f1f3e43f6950975f97ff7c2858bcc5a')
```

- Authentification with OAuth credentials
```ruby
Kuvera::Api.me
# => {"id"=>1, "admin_id"=>2, "name"=>"Kuvera Carrier"}
```

- Secret files uploading
```ruby
Kuvera::Api.upload('My Passport', File.open('passport.pdf'), 'application/pdf')
# => {"address"=>"KEY-11ff53da91ba292ef628b457895bf7ea", "status"=>"success", "title"=>"My Passport"}
```

- Secrets sharing
```ruby
Kuvera::Api.share('KEY-11ff53da91ba292ef628b457895bf7ea')
# => {"path"=>"https://kuvera.io/at/SHARE-d00a96d19889639a5a5d3991c6fab49d", "status"=>"success"}
```

In order to use carrier-related methods you need to provide `OAUTH_UID` and `OAUTH_SECRET`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CleverLabs/kuvera-api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
