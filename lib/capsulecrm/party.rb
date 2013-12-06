class CapsuleCRM::Party < CapsuleCRM::Base

  define_attribute_methods [:contacts]

  # nodoc
  def addresses
    return @addresses if @addresses
    data = raw_data.try(:[], 'contacts').try(:[], 'address')
    @addresses = data ? CapsuleCRM::Address.init_many(self, data) : CapsuleCRM::ContactCollection.new(self,CapsuleCRM::Address, [])
  end

  @@custom_field_definitions = nil
  # nodoc
  def self.custom_field_definitions
    @@custom_field_definitions ||= begin
      path = self.get_path
      path = [path, '/customfield/definitions'].join
      last_response = self.get(path)
      data = last_response['customFieldDefinitions'].try(:[], 'customFieldDefinition')
      CapsuleCRM::CustomFieldDefinition.init_many(self, data)
    end
  end
  
  # nodoc
  def custom_fields
    return @custom_fields if @custom_fields
    path = self.class.get_path
    path = [path, '/', id, '/customfield'].join
    last_response = self.class.get(path)
    data = last_response['customFields'].try(:[], 'customField')
    @custom_fields = CapsuleCRM::CustomField.init_many(self, data)
  end

  #nodoc
  def history_items
    return @history_items if @history_items
    path = self.class.get_path
    path = [path, '/', id, '/history'].join
    last_response = self.class.get(path)
    data = last_response['history'].try(:[], 'historyItem')
    @history_items = CapsuleCRM::HistoryItem.init_many(self, data)
  end

  def tags
    return @tags if @tags
    path = self.class.get_path
    path = [path, '/', id, '/tag'].join
    last_response = self.class.get(path)
    #raise last_response.inspect
    data = last_response['tags'].try(:[], 'tag')
    @tags = CapsuleCRM::Tag.init_many(self, data)
  end

  def opportunities
    return @opportunities if @opportunities
    path = self.class.get_path
    path = [path, '/', id, '/opportunity'].join
    last_response = self.class.get(path)
    @opportunities = CapsuleCRM::Opportunity.init_many(last_response)
  end

  def tasks
    return @tasks if @tasks
    path = self.class.get_path
    path = [path, '/', id, '/tasks'].join
    last_response = self.class.get(path)
    @tasks = CapsuleCRM::Task.init_many(last_response)
  end

  def tag_names
    tags.map(&:name)
  end

  # nodoc
  # Merge together all contact details into a single contacts structure for uploading
  def contacts
    collection = CapsuleCRM::ContactCollection.new(self,CapsuleCRM::Contact, [])
    collection.concat emails
    collection.concat phone_numbers
    collection.concat websites
    collection.concat addresses
    collection
  end

  # nodoc
  def emails
    return @emails if @emails
    data = raw_data.try(:[], 'contacts').try(:[], 'email')
    @emails = data ? CapsuleCRM::Email.init_many(self, data) : CapsuleCRM::ContactCollection.new(self,CapsuleCRM::Email, [])
  end
  
  # nodoc
  def phone_numbers
    return @phone_numbers if @phone_numbers
    data = raw_data.try(:[], 'contacts').try(:[], 'phone')
    @phone_numbers = data ? CapsuleCRM::Phone.init_many(self, data) : CapsuleCRM::ContactCollection.new(self,CapsuleCRM::Phone, [])
  end

  # nodoc
  def websites
    return @websites if @websites
    data = raw_data.try(:[], 'contacts').try(:[], 'website')
    @websites = data ? CapsuleCRM::Website.init_many(self, data) : CapsuleCRM::ContactCollection.new(self,CapsuleCRM::Website, [])
  end

  def is?(kind)
    required_class = kind.to_s.camelize
    self.class.to_s.include? required_class
  end

  # nodoc
  def self.get_path
    '/api/party'
  end

  def delete!
    path = self.class.get_path
    path = [path, '/', id].join
    self.class.delete(path)    
  end

  def self.find_all_by_email(email, options={})
    options[:email] = email
    find_all(options)
  end


  # nodoc
  def self.find_by_email(email)
    find_all_by_email(email, :limit => 1, :offset => 0).first
  end


  # nodoc
  def self.search(query, options={})
    options[:q] = query
    find_all(options)
  end

  def self.init_one(response)
    return CapsuleCRM::Person.init_one(response) if response['person']
    return CapsuleCRM::Organisation.init_one(response) if response['organisation']
    raise CapsuleCRM::RecordNotRecognised, "Could not recognise returned entity type: #{response}"
  end
end
