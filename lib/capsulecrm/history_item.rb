class CapsuleCRM::HistoryItem < CapsuleCRM::Child

  attr_accessor :type
  attr_accessor :entry_date
  attr_accessor :creator
  attr_accessor :note
  attr_accessor :subject
  attr_accessor :note
  attr_accessor :attachments
  attr_accessor :participants


  # nodoc
  def self.xml_map
    map = {
      'type' => 'type',
      'entryDate' => 'entry_date',
      'creator' => 'creator',
      'note' => 'note',
      'attachments' => 'attachments',
      'participants' => 'participants'
    }
    super.merge map
  end


end
