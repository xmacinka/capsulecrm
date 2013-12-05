class CapsuleCRM::HistoryItem < CapsuleCRM::Base

  attr_accessor :type
  attr_accessor :entry_date
  attr_accessor :creator
  attr_accessor :creator_name
  attr_accessor :note
  attr_accessor :subject
  attr_accessor :attachments
  attr_accessor :participants
  attr_accessor :opportunity_id
  attr_accessor :party_id

  define_attribute_methods [:type, :entry_date, :creator, :creator_name, :note, :subject, :attachments, :participants, :party_id]

  # nodoc
  def attributes
    attrs = {}
    arr = [:type, :entry_date, :creator, :creator_name, :note, :subject, :attachments, :participants, :party_id]
    arr.each do |key|
      attrs[key] = self.send(key) if self.send(key)
    end
    attrs
  end

  # nodoc
  def self.xml_root
    'historyItem'
  end

  # nodoc
  def self.xml_map
    map = {
      'type' => 'type',
      'entryDate' => 'entry_date',
      'creator' => 'creator',
      'creatorName' => 'creator_name',
      'note' => 'note',
      'subject' => 'subject',
      'attachments' => 'attachments',
      'participants' => 'participants',
      'partyId' => 'party_id',
    }
    super.merge map
  end

  def save
    new_record?? create : update
  end

  private

  def create
    raise ArgumentError, "opportunity_id not defined" if self.opportunity_id.nil?
    path = '/api/opportunity/' + self.opportunity_id.to_s + '/history'
    options = {:path => path}
    new_id = self.class.create attributes, options
  end

  # nodoc
  def update
    path = '/api/history/' + id.to_s
    options = {:path => path}
    success = self.class.update id, dirty_attributes, options
    changed_attributes.clear if success
    success
  end

end
