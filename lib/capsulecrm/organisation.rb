class CapsuleCRM::Organisation < CapsuleCRM::Party

  attr_accessor :about
  attr_accessor :name

  define_attribute_methods [:about, :name]

  # nodoc
  def attributes
    attrs = {}
    arr = [:about, :name, :contacts]
    arr.each do |key|
      attrs[key] = self.send(key)
    end
    attrs
  end

  def save
    new_record?? create : update
  end

  # nodoc
  def create
    path = '/api/organisation'
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
  def update
    path = '/api/organisation/' + id.to_s
    options = {:root => 'organisation', :path => path}
    success = self.class.update id, dirty_attributes, options
    changed_attributes.clear if success
    success
  end

  # nodoc
  def dirty_attributes
    Hash[attributes.select { |k,v| changed.include? k.to_s }]
  end

  # nodoc
  def people
    return @people if @people
    path = self.class.get_path
    path = [path, '/', id, '/people'].join
    last_response = self.class.get(path)
    @people = CapsuleCRM::Person.init_many(last_response)
  end


  # nodoc
  def self.init_many(response)
    begin
      data = response['parties']['organisation']
    rescue MultiXml::ParseError => e

      response = MultiXml.parse(response.body.gsub("\u0000",''))
      data = response['parties']['organisation']
    end

    CapsuleCRM::Collection.new(self, data)
  end


  # nodoc
  def self.init_one(response)
    data = response['organisation']
    new(attributes_from_xml_hash(data))
  end


  # nodoc
  def self.xml_map
    map = {
      'about' => 'about',
      'name' => 'name'
    }
    super.merge map
  end


end
