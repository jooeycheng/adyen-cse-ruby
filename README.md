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
  card.holder_name  = "Adyen Shopper"
  card.number       = "4111111111111111"
  card.expiry_month = "08"
  card.expiry_year  = "2018"
  card.cvc          = "737"
end

encrypted_card = cse.encrypt!
```
