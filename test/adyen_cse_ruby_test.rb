require 'test_helper'

class AdyenCseRubyTest < Minitest::Test

  EXPONENT = "10001"
  MODULUS  = "9201EBD5DC974FDE613A85AFF2728627FD2C227F18CF1C864FBBA3781908BB7BD72C818FC37D0B70EF8708705C623DF4A9427A" \
             "051B3C8205631716AAAC3FCB76114D91036E0CAEFA454254D135A1A197C1706A55171D26A2CC3E9371B86A725458E82AB82C84" \
             "8AB03F4F0AF3127E7B2857C3B131D52B02F9A408F4635DA7121B5B4A53CEDE687D213F696D3116EB682A4CEFE6EDFC54D25B7C" \
             "57D345F990BB5D8D0C92033639FAC27AD232D9D474896668572F494065BC7747FF4B809FE3084A5E947F72E59309EDEAA5F2D8" \
             "1027429BF4827FB62006F763AFB2153C4A959E579390679FFD7ADE1DFE627955628DC6F2669A321626D699A094FFF98243A7C105"

  TEST_CARD = { holder_name: "Adyen Shopper", number: "4111111111111111", expiry_month: "01", expiry_year: "2018", cvc: "737" }

  def public_key
    EXPONENT + "|" + MODULUS
  end

  def test_that_it_has_a_version_number
    refute_nil ::AdyenCseRuby::VERSION
  end

  def test_initialize_encrypter
    cse = AdyenCseRuby::Encrypter.new do |card|
      card.public_key   = public_key
      card.holder_name  = TEST_CARD[:holder_name]
      card.number       = TEST_CARD[:number]
      card.expiry_month = TEST_CARD[:expiry_month]
      card.expiry_year  = TEST_CARD[:expiry_year]
      card.cvc          = TEST_CARD[:cvc]
    end

    assert_equal cse.public_key, public_key
    assert_instance_of Time, cse.generation_time

    json = cse.card_data_json
    assert_equal json.keys.sort, ["cvc", "expiryMonth", "expiryYear", "generationtime", "holderName", "number"]
    assert_equal TEST_CARD[:holder_name], json["holderName"]
    assert_equal TEST_CARD[:number], json["number"]
    assert_equal TEST_CARD[:expiry_month], json["expiryMonth"]
    assert_equal TEST_CARD[:expiry_year], json["expiryYear"]
    assert_equal TEST_CARD[:cvc], json["cvc"]
  end
end
