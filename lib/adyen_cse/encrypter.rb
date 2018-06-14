require "securerandom"
require "base64"
require "openssl/ccm"
require "json"

module AdyenCse
  class Encrypter
    PREFIX  = "adyenrb"
    VERSION = "0_1_1"

    attr_reader :public_key

    def initialize(public_key)
      @public_key = public_key
    end

    def encrypt!(params = {})
      validate!(params.keys)

      key   = SecureRandom.random_bytes(32)
      nonce = SecureRandom.random_bytes(12)
      generation_time = params.fetch(:generation_time, Time.now)

      # keys sorted alphabetically
      json_data = {
        "cvc" => params[:cvc],
        "expiryMonth" => params[:expiry_month],
        "expiryYear" => params[:expiry_year],
        "generationtime" => generation_time.utc.strftime("%FT%T.%LZ"),
        "holderName" => params[:holder_name],
        "number" => params[:number],
      }.to_json

      ccm = OpenSSL::CCM.new("AES", key, 8)
      encrypted_card = ccm.encrypt(json_data, nonce)

      rsa = self.class.parse_public_key(public_key)
      encrypted_aes_key = rsa.public_encrypt(key)

      encrypted_card_component = nonce + encrypted_card

      [PREFIX, VERSION, "$", Base64.strict_encode64(encrypted_aes_key), "$", Base64.strict_encode64(encrypted_card_component)].join
    end

    def self.parse_public_key(public_key)
      exponent, modulus = public_key.split("|").map { |n| n.to_i(16) }

      rsa = OpenSSL::PKey::RSA.new
      rsa.set_key(OpenSSL::BN.new(modulus), OpenSSL::BN.new(exponent), nil)
    end

    private

    def validate!(params)
      %i(holder_name number expiry_month expiry_year cvc).each do |param|
        raise ArgumentError, "param `#{param}' is required" unless params.include?(param)
      end
    end
  end
end
