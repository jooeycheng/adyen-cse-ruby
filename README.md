[![Gem Version](https://badge.fury.io/rb/adyen-cse-ruby.svg)](https://badge.fury.io/rb/adyen-cse-ruby)
[![Build Status](https://travis-ci.org/jooeycheng/adyen-cse-ruby.svg?branch=master)](https://travis-ci.org/jooeycheng/adyen-cse-ruby)
[![](https://api.codeclimate.com/v1/badges/ac46c6f16792ed094d7f/maintainability)](https://codeclimate.com/github/jooeycheng/adyen-cse-ruby/maintainability)

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

## factory_bot integration
Example of an `:adyen_test_card` factory with [factory_bot](https://github.com/thoughtbot/factory_bot).

```ruby
# ./spec/factories/adyen_test_card.rb

require 'adyen_cse'

class AdyenTestCard
  attr_reader :holder_name, :number, :expiry_month, :expiry_year, :cvc
  
  PUBLIC_KEY = "your_public_key_here"

  def initialize(params = {})
    @holder_name  = params[:holder_name]
    @number       = params[:number]
    @expiry_month = params[:expiry_month]
    @expiry_year  = params[:expiry_year]
    @cvc          = params[:cvc]
  end

  def nonce
    AdyenCse::Encrypter.new(PUBLIC_KEY).encrypt!(
      holder_name: holder_name,
      number: number,
      expiry_month: expiry_month,
      expiry_year: expiry_year,
      cvc: cvc
    )
  end
end

FactoryBot.define do
  factory :adyen_test_card do
    sequence(:holder_name) { |n| "Shopper #{n}" }
    expiry_month { '08' }
    expiry_year { '2018' }
    cvc { '737' }
    
    visa

    trait :visa do
      number { 4111_1111_1111_1111.to_s }
    end

    trait :mastercard do
      number { 5555_5555_5555_4444.to_s }
    end

    trait :amex do
      number { 3451_779254_88348.to_s }
      cvc { '7373' }
    end

    skip_create
    initialize_with { new(attributes) }
  end
end
```

Example usage:
```ruby
RSpec.describe ExamplePaymentService do
  let(:credit_card) { FactoryBot.build(:adyen_test_card) }
  ...
end
```
