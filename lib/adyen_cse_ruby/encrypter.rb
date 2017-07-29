module AdyenCseRuby
  class Encrypter
    PREFIX    = "adyenan"
    VERSION   = "0_1_1"
    SEPARATOR = "$"

    attr_accessor :public_key, :holder_name, :number, :expiry_month, :expiry_year, :cvc, :generation_time

    def initialize
      yield self
    end
  end
end
