require 'test_helper'
class CreatePersonTest < Test::Unit::TestCase

  # nodoc
  def setup
  end

  def test_xml_generation
    # Setup
    person = CapsuleCRM::Person.new
    person.first_name = 'Homer'
    person.last_name = 'Simpson'
    person.emails << CapsuleCRM::Email.new(person, :type => 'Work', :address => 'homer.simpson@springfield-nuclear.com')
    person.phone_numbers << CapsuleCRM::Phone.new(person, :type => 'Work', :number => '+1 888 555555')
    person.websites << CapsuleCRM::Website.new(person, :type => 'Work', :web_address => 'www.springfield-nuclear.com', :web_service => 'URL')
    person.addresses << CapsuleCRM::Address.new(person, :type => 'Office', :street => '100 Industrial Way', :city => 'Springfield', :state => "??", :zip => '12345', :country => 'United States')
    # test that XML is generated correctly
    xml = CapsuleCRM::Person.attributes_to_xml(person.attributes)
    assert_equal xml, <<-EOF
<?xml version="1.0" encoding="UTF-8"?>
<person>
  <about nil="true"/>
  <firstName>Homer</firstName>
  <lastName>Simpson</lastName>
  <title nil="true"/>
  <jobTitle nil="true"/>
  <organisationId nil="true"/>
  <contacts>
    <email>
      <type>Work</type>
      <emailAddress>homer.simpson@springfield-nuclear.com</emailAddress>
    </email>
    <phone>
      <type>Work</type>
      <phoneNumber>+1 888 555555</phoneNumber>
    </phone>
    <website>
      <type>Work</type>
      <webAddress>www.springfield-nuclear.com</webAddress>
      <webService>URL</webService>
    </website>
    <address>
      <type>Office</type>
      <street>100 Industrial Way</street>
      <city>Springfield</city>
      <state>??</state>
      <zip>12345</zip>
      <country>United States</country>
    </address>
  </contacts>
</person>
    EOF
  end

  # nodoc
  def test_success
    VCR.use_cassette('create_person') do

      # save a new object, check for the id
      person = CapsuleCRM::Person.new
      person.first_name = 'Homer'
      person.last_name = 'Simpson'
      assert person.save
      assert !person.id.nil?


      # check it was persisted
      person = CapsuleCRM::Person.find person.id
      assert_equal 'Homer', person.first_name
      assert_equal 'Simpson', person.last_name

    end
  end


  # nodoc
  def teardown
    WebMock.reset!
  end


end
