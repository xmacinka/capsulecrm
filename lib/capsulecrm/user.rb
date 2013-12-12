class CapsuleCRM::User < CapsuleCRM::Base

  attr_accessor :username
  attr_accessor :name
  attr_accessor :currency
  attr_accessor :timezone
  attr_accessor :logged_in
  attr_accessor :party_id


  define_attribute_methods [:username, :name, :currency, :timezone, :logged_in, :party_id]

  def self.get_path
    '/api/users'
  end
  
  private

  # -- Class methods --

  
  # nodoc
  def self.init_many(response)
    data = response['users'].try(:[], 'user')
    CapsuleCRM::Collection.new(self, data)
  end
  
  # nodoc
  def self.init_one(response)
    data = response['user']
    new(attributes_from_xml_hash(data))
  end

  # nodoc
  def self.xml_map
    map = {
      'username' => 'username',
      'name' => 'name',
      'currency' => 'currency',
      'timezone' => 'timezone',
      'loggedIn' => 'logged_in',
      'partyId' => 'party_id',
    }
    super.merge map
  end


end
