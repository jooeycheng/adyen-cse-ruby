Note to self.

## Developing

1. Run `bin/setup` to install dependencies
2. Run `bundle exec rake test` to run the tests
3. Run `bin/console` for an interactive prompt (optional, for debugging)

## Releasing New Version

1. Update version number in `version.rb`
2. Run `bundle exec rake release`. This will:
   1. Create a git tag with the version number
   2. Push git commits and tags to remote
   3. Push the `.gem` file to [rubygems.org](https://rubygems.org)
