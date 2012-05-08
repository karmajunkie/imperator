require 'uuidtools'
class Imperator::Command
  include ActiveAttr::Model
  extend ActiveModel::Callbacks

  define_model_callbacks :create, :perform, :initialize

  cattr_accessor :commit_mode
  attribute :id

  after_initialize :set_uuid

  class << self
    attr_accessor :perform_block
  end

  def self.action(&block)
    @perform_block = block
  end

  alias_method :params, :attributes

  def as_json
    attributes.as_json
  end

  def persisted?
    false
  end

  def commit!
    raise Imperator::InvalidCommandError.new "Command was invalid" unless valid?
    self.commit
  end

  def commit
    #TODO: background code for this
    self.perform
  end

  def initialize(*)
    run_callbacks :initialize do
      super
    end
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
    run_callbacks :perform do 
      self.instance_exec(&self.class.perform_block)
    end
  end

  def method_missing(method, *args)
    method_root = method.to_s.gsub(/=$/, "")
    if method.to_s[/=$/]
      self.attributes[method_root] = args.first
    elsif attributes.has_key?(method_root)
      self.attributes[method]
    else
      super
    end
  end

  private 
  def set_uuid
    self.id = UUIDTools::UUID.timestamp_create.to_s if self.id.nil?
  end
end
