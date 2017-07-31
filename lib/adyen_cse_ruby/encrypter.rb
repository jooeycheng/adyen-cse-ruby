module AdyenCseRuby
  class Encrypter
    PREFIX    = "adyenan"
    VERSION   = "0_1_1"
    SEPARATOR = "$"

    attr_accessor :public_key, :holder_name, :number, :expiry_month, :expiry_year, :cvc, :generation_time

    def initialize
      yield self
      self.generation_time ||= Time.now
    end

    def card_data_json
      # keys sorted alphabetically
      {
        "cvc" => cvc,
        "expiryMonth" => expiry_month,
        "expiryYear" => expiry_year,
        "generationtime" => generation_time.utc.strftime("%FT%T.%LZ"),
        "holderName" => holder_name,
        "number" => number,
      }.to_json
    end

    def self.parse_public_key(public_key)
      exponent, modulus = public_key.split("|").map { |n| n.to_i(16) }

      OpenSSL::PKey::RSA.new.tap do |rsa|
        rsa.e = OpenSSL::BN.new(exponent)
        rsa.n = OpenSSL::BN.new(modulus)
      end
    end
  end
end
