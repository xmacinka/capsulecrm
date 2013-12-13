class CapsuleCRM::Opportunity < CapsuleCRM::Base

  attr_accessor :name
  attr_accessor :currency
  attr_accessor :value
  attr_accessor :milestone, :probability
  attr_accessor :party_id
  attr_accessor :description
  attr_accessor :duration, :duration_basis
  attr_accessor :expected_close_date
  attr_accessor :actual_close_date
  attr_accessor :owner


  define_attribute_methods [:name, :currency, :value, :milestone, :probability, :description, :duration, :duration_basis, :expected_close_date, :actual_close_date, :owner]

  def self.get_path
    '/api/opportunity'
  end
  

  # nodoc
  def attributes
    attrs = {}
    arr = [:name, :currency, :value, :milestone, :probability, :description, :duration, :duration_basis, :expected_close_date, :owner]
    arr.each do |key|
      attrs[key] = self.send(key) if self.send(key)
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
  def expected_close_date=(value)
    expected_close_date_will_change! unless value == expected_close_date
    @expected_close_date = value
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
  
  # nodoc
  def custom_fields
    return @custom_fields if @custom_fields
    path = self.class.get_path
    path = [path, '/', id, '/customfield'].join
    last_response = self.class.get(path)
    data = last_response['customFields'].try(:[], 'customField')
    @custom_fields = CapsuleCRM::CustomField.init_many(self, data)
  end

  private

  # nodoc
  def create
    raise ArgumentError, "party_id not defined" if self.party_id.nil?
    path = '/api/party/'+self.party_id.to_s+'/opportunity'
    options = {:path => path}
    new_id = self.class.create attributes, options
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
    data = response['parties'].try(:[], 'opportunity') || response['opportunities'].try(:[], 'opportunity')
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
      'milestone' => 'milestone',
      'probability' => 'probability',
      'description' => 'description',
      'duration' => 'duration',
      'durationBasis' => 'duration_basis',
      'expectedCloseDate' => 'expected_close_date',
      'actualCloseDate' => 'actual_close_date',
      'owner' => 'owner',
      'partyId' => 'party_id',
    }
    super.merge map
  end


end
