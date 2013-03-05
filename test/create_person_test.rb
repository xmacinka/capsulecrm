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
    # test that XML is generated correctly
    xml = CapsuleCRM::Person.attributes_to_xml(person.attributes, 'person')
    assert_equal xml, <<-EOF
<?xml version="1.0" encoding="UTF-8"?>
<person>
  <about nil="true"/>
  <firstName>Homer</firstName>
  <lastName>Simpson</lastName>
  <title nil="true"/>
  <jobTitle nil="true"/>
  <organisationId nil="true"/>
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
