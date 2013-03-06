class CapsuleCRM::CustomField < CapsuleCRM::Child

  attr_accessor :boolean
  attr_accessor :date
  attr_accessor :label
  attr_accessor :text
  attr_accessor :tag

  def attributes
    attrs = {}
    arr = [:label, :text, :tag, :date, :boolean]
    arr.each do |key|
      attrs[key] = self.send(key)
    end
    attrs
  end


  # nodoc
  def boolean=(value)
    return @boolean = true if value.to_s == 'true'
    @boolean = false
  end


  # nodoc
  def date=(value)
    value = Time.parse(value) if value.is_a?(String)
    @date = value
  end


  # nodoc
  def value
    date || text || boolean
  end


  # nodoc
  def save
    # All things are PUTs
    update
  end

  # nodoc
  def self.xml_root
    'customField'
  end

  # nodoc
  def self.xml_map
    map = {
      'label' => 'label',
      'text' => 'text',
      'date' => 'date',
      'boolean' => 'boolean',
      'tag' => 'tag'
    }
    super.merge map
  end

  private

  # nodoc
  def dirty_attributes
    Hash[attributes.select { |k,v| changed.include? k.to_s }]
  end

  # nodoc
  def update
    # Update
    path = parent.class.get_path+'/'+parent.id.to_s+'/customfields'
    options = {:path => path, :wrap => 'customFields'}
    success = self.class.update id, attributes, options
    changed_attributes.clear if success
    success
  end
  
end
