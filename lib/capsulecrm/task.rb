class CapsuleCRM::Task < CapsuleCRM::Base

  attr_accessor :description
  attr_accessor :due_date_time
  attr_accessor :owner
  attr_accessor :category
  attr_accessor :party_id
  attr_accessor :detail


  define_attribute_methods [:description, :due_date_time, :owner, :category, :detail]

  def self.get_path
    '/api/task'
  end

  # nodoc
  def attributes
    attrs = {}
    arr = [:description, :due_date_time, :owner, :category, :detail]
    arr.each do |key|
      attrs[key] = self.send(key)
    end
    attrs
  end

  # nodoc
  def save
    new_record?? create : update
  end
  
  private

  # nodoc
  def create
    raise ArgumentError, "party_id not defined" if self.party_id.nil?
    path = '/api/party/'+self.party_id.to_s+'/task'
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
    path = '/api/task/' + id.to_s
    options = {:path => path}
    success = self.class.update id, dirty_attributes, options
    changed_attributes.clear if success
    success
  end


  # -- Class methods --

  
  # nodoc
  def self.init_many(response)
    data = response['tasks'].try(:[], 'task')
    CapsuleCRM::Collection.new(self, data)
  end


  # nodoc
  def self.init_one(response)
    data = response['task']
    new(attributes_from_xml_hash(data))
  end


  # nodoc
  def self.xml_map
    map = {
      'description' => 'description',
      'dueDateTime' => 'due_date_time',
      'owner' => 'owner',
      'category' => 'category',
      'detail' => 'detail',
    }
    super.merge map
  end


end
