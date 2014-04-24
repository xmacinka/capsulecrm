class CapsuleCRM::Tag < CapsuleCRM::Child

  attr_accessor :name

  def attributes
    attrs = {}
    arr = [:name]
    arr.each do |key|
      attrs[key] = self.send(key)
    end
    attrs
  end

  # nodoc
  def save
    create
  end

  # nodoc
  def self.xml_root
    'tag'
  end

  # nodoc
  def self.xml_map
    map = {
      'name' => 'name'
    }
    super.merge map
  end

  private

  # nodoc
  def create
    path = parent.class.get_path+'/'+parent.id.to_s+'/tag/'+CGI.escape(name)
    options = {:path => path, :wrap => 'tags'}
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

end
