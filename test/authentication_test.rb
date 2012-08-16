require 'test_helper'
class AuthenticationTest < Test::Unit::TestCase

  def test_success_for_base
    CapsuleCRM.account_name = "a"
    CapsuleCRM.api_token = "abcd1234"
    CapsuleCRM.initialize!
    # p = CapsuleCRM::Person.new

    assert_equal CapsuleCRM::Base.base_uri, "https://a.capsulecrm.com"
    assert_equal CapsuleCRM::Base.default_options[:basic_auth], {:username=>"abcd1234", :password=>"x"}
    assert_equal CapsuleCRM::Person.base_uri, "https://a.capsulecrm.com"
    assert_equal CapsuleCRM::Person.default_options[:basic_auth], {:username=>"abcd1234", :password=>"x"}

    CapsuleCRM.account_name = "b"
    CapsuleCRM.api_token = "efgh5678"
    CapsuleCRM.initialize!

    assert_equal CapsuleCRM::Base.base_uri, "https://b.capsulecrm.com"
    assert_equal CapsuleCRM::Base.default_options[:basic_auth], {:username=>"efgh5678", :password=>"x"}
    assert_equal CapsuleCRM::Person.base_uri, "https://b.capsulecrm.com"
    assert_equal CapsuleCRM::Person.default_options[:basic_auth], {:username=>"efgh5678", :password=>"x"}
  end
end