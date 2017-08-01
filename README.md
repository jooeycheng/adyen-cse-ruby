# Adyen CSE for Ruby

Adyen's Client Side Encryption (CSE) library for Ruby.

This is a port of [Adyen's Android CSE library](https://github.com/Adyen/adyen-cse-android), packaged as a Ruby gem.

Check out the Python version [here](https://github.com/cheah/adyen-cse-python).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'adyen-cse-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install adyen-cse-ruby

## Usage

```ruby
cse = AdyenCse::Encrypter.new(public_key) do |card|
  card.holder_name  = TEST_CARD[:holder_name]
  card.number       = TEST_CARD[:number]
  card.expiry_month = TEST_CARD[:expiry_month]
  card.expiry_year  = TEST_CARD[:expiry_year]
  card.cvc          = TEST_CARD[:cvc]
end

encrypted_nonce = cse.encrypt!
```
