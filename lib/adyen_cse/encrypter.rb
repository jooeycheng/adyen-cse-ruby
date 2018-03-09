require "securerandom"
require "base64"
require "openssl/ccm"
require "json"

module AdyenCse
  class Encrypter
    PREFIX  = "adyenrb"
    VERSION = "0_1_1"

    attr_reader   :public_key
    attr_accessor :holder_name, :number, :expiry_month, :expiry_year, :cvc, :generation_time

    def initialize(public_key)
      @public_key = public_key
      yield self rescue nil
      self.generation_time ||= Time.now
    end

    def encrypt!
      validate!

      key   = SecureRandom.random_bytes(32)
      nonce = SecureRandom.random_bytes(12)
      data  = card_data.to_json

      ccm = OpenSSL::CCM.new("AES", key, 8)
      encrypted_card = ccm.encrypt(data, nonce)

      rsa = self.class.parse_public_key(public_key)
      encrypted_aes_key = rsa.public_encrypt(key)

      encrypted_card_component = nonce + encrypted_card

      [PREFIX, VERSION, "$", Base64.strict_encode64(encrypted_aes_key), "$", Base64.strict_encode64(encrypted_card_component)].join
    end

    def card_data
      # keys sorted alphabetically
      {
        "cvc" => cvc,
        "expiryMonth" => expiry_month,
        "expiryYear" => expiry_year,
        "generationtime" => generation_time.utc.strftime("%FT%T.%LZ"),
        "holderName" => holder_name,
        "number" => number,
      }
    end

    def self.parse_public_key(public_key)
      exponent, modulus = public_key.split("|").map { |n| n.to_i(16) }

      OpenSSL::PKey::RSA.new.tap do |rsa|
        rsa.e = OpenSSL::BN.new(exponent)
        rsa.n = OpenSSL::BN.new(modulus)
      end
    end

    private

    def validate!
      %w(holder_name number expiry_month expiry_year cvc generation_time).each do |param|
        raise ArgumentError, "param `#{param}' is required" if instance_variable_get("@#{param}").nil?
      end
    end
  end
end
