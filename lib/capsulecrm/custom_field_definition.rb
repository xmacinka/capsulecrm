class CapsuleCRM::CustomFieldDefinition < CapsuleCRM::Child

  attr_accessor :label
  attr_accessor :type
  attr_accessor :tag
  attr_accessor :options

  def attributes
    attrs = {}
    arr = [:label, :type, :tag, :options]
    arr.each do |key|
      attrs[key] = self.send(key)
    end
    attrs
  end


  # nodoc
  def self.xml_root
    'customFieldDefinition'
  end

  # nodoc
  def self.xml_map
    map = {
      'label' => 'label',
      'type' => 'type',
      'tag' => 'tag',
      'options' => 'options',
    }
    super.merge map
  end

end
