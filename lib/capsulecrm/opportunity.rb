class CapsuleCRM::Opportunity < CapsuleCRM::Base

  attr_accessor :name


  define_attribute_methods [:name]

  def self.get_path
    '/api/opportunity'
  end
  

  # nodoc
  def attributes
    attrs = {}
    arr = [:name]
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
  #def organisation
  #  return nil if organisation_id.nil?
  #  @organisation ||= CapsuleCRM::Organisation.find(organisation_id)
  #end


  # nodoc
  def save
    new_record?? create : update
  end


  private


  # nodoc
  def create
    path = '/api/opportunity'
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
      'name' => 'name'
    }
    super.merge map
  end


end
