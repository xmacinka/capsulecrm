class CapsuleCRM::Email < CapsuleCRM::Contact

  attr_accessor :address

  # nodoc
  def attributes
    attrs = {}
    arr = [:type, :address]
    arr.each do |key|
      attrs[key] = self.send(key)
    end
    attrs
  end

  # nodoc
  def self.xml_map
    map = {
      'emailAddress' => 'address'
    }
    super.merge map
  end


end
