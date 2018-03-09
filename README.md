[![Build Status](https://travis-ci.org/jooeycheng/adyen-cse-ruby.svg?branch=master)](https://travis-ci.org/jooeycheng/adyen-cse-ruby)

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
require 'adyen_cse'

cse = AdyenCse::Encrypter.new(public_key)

encrypted_card = cse.encrypt!(
  holder_name: "Adyen Shopper",
  number: 4111_1111_1111_1111.to_s,
  expiry_month: "08",
  expiry_year: "2018",
  cvc: "737"
)
```

Optionally, you may pass a custom `generation_time` to mock expired data.

```ruby
encrypted_card = cse.encrypt!(
  ...,
  generation_time: Time.new(2015, 10, 21)
)
```
