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
    cse = AdyenCseRuby::Encrypter.new(public_key) do |card|
      card.holder_name  = TEST_CARD[:holder_name]
      card.number       = TEST_CARD[:number]
      card.expiry_month = TEST_CARD[:expiry_month]
      card.expiry_year  = TEST_CARD[:expiry_year]
      card.cvc          = TEST_CARD[:cvc]
    end

    assert_equal cse.public_key, public_key
    assert_instance_of Time, cse.generation_time

    card_data = cse.card_data
    assert_equal card_data.keys.sort, ["cvc", "expiryMonth", "expiryYear", "generationtime", "holderName", "number"]
    assert_equal TEST_CARD[:holder_name], card_data["holderName"]
    assert_equal TEST_CARD[:number], card_data["number"]
    assert_equal TEST_CARD[:expiry_month], card_data["expiryMonth"]
    assert_equal TEST_CARD[:expiry_year], card_data["expiryYear"]
    assert_equal TEST_CARD[:cvc], card_data["cvc"]
  end

  def test_parse_public_key
    pubkey = AdyenCseRuby::Encrypter.parse_public_key(public_key)

    assert_equal 2048, pubkey.n.num_bytes * 8
    assert_equal EXPONENT.to_i(16), pubkey.e
    assert_equal MODULUS.to_i(16), pubkey.n
  end

  def test_encrypted_nonce_format
    cse = AdyenCseRuby::Encrypter.new(public_key) do |card|
      card.holder_name  = TEST_CARD[:holder_name]
      card.number       = TEST_CARD[:number]
      card.expiry_month = TEST_CARD[:expiry_month]
      card.expiry_year  = TEST_CARD[:expiry_year]
      card.cvc          = TEST_CARD[:cvc]
    end
    encrypted_nonce = cse.encrypt

    assert encrypted_nonce.start_with?(AdyenCseRuby::Encrypter::PREFIX + AdyenCseRuby::Encrypter::VERSION)
    assert_equal 2, encrypted_nonce.count("$")
  end

  def test_ccm_encryption
    key        = ["404142434445464748494a4b4c4d4e4f"].pack('H*')
    nonce      = ["10111213141516"].pack('H*')
    data       = ["68656c6c6f20776f726c642121"].pack('H*')
    ciphertext = ["39264f148b54c456035de0a531c8344f46db12b388"].pack('H*')

    cipher = OpenSSL::CCM.new("AES", key, 8)

    assert_equal ciphertext, cipher.encrypt(data, nonce)
  end
end
