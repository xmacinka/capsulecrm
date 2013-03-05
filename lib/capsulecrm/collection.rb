class CapsuleCRM::Collection < Array


  # nodoc
  def initialize(klass, data)
    return if data.nil?
    [data].flatten.each do |attributes|
      attributes = klass.attributes_from_xml_hash(attributes)
      self.push klass.new(attributes)
    end
  end

  def to_xml(options)
    super(options.merge(:root => self.class.xml_root, :skip_types => true))
  end

  def self.xml_root
    nil
  end

end
