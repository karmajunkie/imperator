class Commando::Command
  include ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization
  include ActiveModel::Serializers::JSON


  cattr_accessor :commit_mode
  attr_accessor :attributes

  class << self
    attr_accessor :perform_block
  end

  def self.perform(&block)
    @perform_block = block
  end

  def self.property(property_name)

    define_method(property_name) do
      @attributes[property_name]
    end
    define_method("#{property_name}=") do |val|
      @attributes[property_name] = val
    end
  end

  def read_attribute_for_validation(key)
    @attributes[key]
  end


  def initialize(params={})
    @attributes = HashWithIndifferentAccess.new params.dup
    @attributes[:id] = UUIDTools::UUID.timestamp_create.to_s if @attributes[:id].nil?
  end

  alias_method :params, :attributes

  def as_json
    attributes.as_json
  end

  def persisted?
    false
  end

  def commit!
    raise Commando::InvalidCommandError.new "Command was invalid" unless valid?
    self.commit
  end

  def commit
    #TODO: background code for this
    self.perform
  end

  def dump
    attributes.to_json
  end

  def self.load(command_string)
    self.new(JSON.parse(command_string))
  end

  def load(command_string)
    self.attributes = HashWithIndifferentAccess.new(JSON.parse(command_string))
  end

  def perform!
    raise InvalidCommandError.new "Command was invalid" unless valid?
    self.perform
  end

  def perform
    raise "You need to define the perform block for #{self.class.name}" unless self.class.perform_block
    debugger
    self.instance_exec(&self.class.perform_block)
  end

  def id
    params[:id]
  end

  def method_missing(method, *args)
    puts "method missing"
    method_root = method.to_s.gsub(/=$/, "")
    if method.to_s[/=$/]
      self.attributes[method_root] = args.first
    elsif attributes.has_key?(method_root)
      self.attributes[method]
    else
      #super
    end
  end
end
