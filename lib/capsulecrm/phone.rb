class CapsuleCRM::Phone < CapsuleCRM::Contact

  attr_accessor :number

  # nodoc
  def attributes
    attrs = {}
    arr = [:type, :number]
    arr.each do |key|
      attrs[key] = self.send(key)
    end
    attrs
  end

  # nodoc
  def self.xml_map
    map = {
      'phoneNumber' => 'number'
    }
    super.merge map
  end


end
