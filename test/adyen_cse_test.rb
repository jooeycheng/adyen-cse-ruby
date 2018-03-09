require 'test_helper'

class AdyenCseTest < Minitest::Test
  EXPONENT = "10001"
  MODULUS  = "9201EBD5DC974FDE613A85AFF2728627FD2C227F18CF1C864FBBA3781908BB7BD72C818FC37D0B70EF8708705C623DF4A9427A" \
             "051B3C8205631716AAAC3FCB76114D91036E0CAEFA454254D135A1A197C1706A55171D26A2CC3E9371B86A725458E82AB82C84" \
             "8AB03F4F0AF3127E7B2857C3B131D52B02F9A408F4635DA7121B5B4A53CEDE687D213F696D3116EB682A4CEFE6EDFC54D25B7C" \
             "57D345F990BB5D8D0C92033639FAC27AD232D9D474896668572F494065BC7747FF4B809FE3084A5E947F72E59309EDEAA5F2D8" \
             "1027429BF4827FB62006F763AFB2153C4A959E579390679FFD7ADE1DFE627955628DC6F2669A321626D699A094FFF98243A7C105"

  TEST_CARD = { holder_name: "Adyen Shopper", number: 4111_1111_1111_1111.to_s, expiry_month: "08", expiry_year: "2018", cvc: "737" }

  def public_key
    EXPONENT + "|" + MODULUS
  end

  def test_that_it_has_a_version_number
    refute_nil ::AdyenCse::VERSION
  end

  def test_initialize_encrypter
    cse = AdyenCse::Encrypter.new(public_key)

    assert_equal cse.public_key, public_key
  end

  def test_parse_public_key
    pubkey = AdyenCse::Encrypter.parse_public_key(public_key)

    assert_equal 2048, pubkey.n.num_bytes * 8
    assert_equal EXPONENT.to_i(16), pubkey.e
    assert_equal MODULUS.to_i(16), pubkey.n
  end

  def test_encrypted_nonce_format
    encrypted_nonce =
      AdyenCse::Encrypter.new(public_key).encrypt!(
        holder_name: TEST_CARD[:holder_name],
        number: TEST_CARD[:number],
        expiry_month: TEST_CARD[:expiry_month],
        expiry_year: TEST_CARD[:expiry_year],
        cvc: TEST_CARD[:cvc],
      )

    assert encrypted_nonce.start_with?(AdyenCse::Encrypter::PREFIX + AdyenCse::Encrypter::VERSION)
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

  def test_validations
    cse = AdyenCse::Encrypter.new(public_key)

    assert_raises ArgumentError do
      cse.encrypt!
    end
  end
end
