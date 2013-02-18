class CapsuleCRM::Opportunity < CapsuleCRM::Base

  attr_accessor :name
  attr_accessor :currency
  attr_accessor :value
  attr_accessor :milestone
  attr_accessor :party_id


  define_attribute_methods [:name, :currency, :value, :milestone]

  def self.get_path
    '/api/opportunity'
  end
  

  # nodoc
  def attributes
    attrs = {}
    arr = [:name, :currency, :value, :milestone]
    arr.each do |key|
      attrs[key] = self.send(key)
    end
    attrs
  end


  # nodoc
  def name=(value)
    name_will_change! unless value == name
    @name = value
  end

  # nodoc
  def currency=(value)
    currency_will_change! unless value == currency
    @currency = value
  end

  # nodoc
  def value=(value2)
    value_will_change! unless value2 == value
    @value = value2
  end


  # nodoc
  def milestone=(value)
    milestone_will_change! unless value == milestone
    @milestone = value
  end


  # nodoc
  #def organisation
  #  return nil if organisation_id.nil?
  #  @organisation ||= CapsuleCRM::Organisation.find(organisation_id)
  #end


  # nodoc
  def save
    new_record?? create : update
  end

  def get_parties
    options = nil
    params = nil
    @@last_response = self.class.get(self.class.get_path+'/'+id.to_s+'/party', :query => params)

    if self.class.last_response['parties']
      self.class.last_response['parties']
    else
      nil
    end
  end


  private


  # nodoc
  def create
    raise ArgumentError, "party_id not defined" if self.party_id.nil?
    path = '/api/party/'+self.party_id.to_s+'/opportunity'
    options = {:root => 'opportunity', :path => path}
    new_id = self.class.create dirty_attributes, options
    unless new_id
      errors << self.class.last_response.response.message
      return false
    end
    @errors = []
    changed_attributes.clear
    self.id = new_id
    self
  end


  # nodoc
  def dirty_attributes
    Hash[attributes.select { |k,v| changed.include? k.to_s }]
  end


  # nodoc
  def update
    path = '/api/opportunity/' + id.to_s
    options = {:root => 'opportunity', :path => path}
    success = self.class.update id, dirty_attributes, options
    changed_attributes.clear if success
    success
  end


  # -- Class methods --

  
  # nodoc
  def self.init_many(response)
    data = response['parties']['opportunity']
    CapsuleCRM::Collection.new(self, data)
  end


  # nodoc
  def self.init_one(response)
    data = response['opportunity']
    new(attributes_from_xml_hash(data))
  end


  # nodoc
  def self.xml_map
    map = {
      'name' => 'name',
      'currency' => 'currency',
      'value' => 'value',
      'milestone' => 'milestone'
    }
    super.merge map
  end


end
