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
      }
    end
  end
end
