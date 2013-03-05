class CapsuleCRM::Website < CapsuleCRM::Contact

  attr_accessor :web_address
  attr_accessor :web_service

  # nodoc
  def attributes
    attrs = {}
    arr = [:type, :web_address, :web_service]
    arr.each do |key|
      attrs[key] = self.send(key)
    end
    attrs
  end

  # nodoc
  def self.xml_map
    map = {
      'webAddress' => 'web_address',
      'webService' => 'web_service'
    }
    super.merge map
  end


end
