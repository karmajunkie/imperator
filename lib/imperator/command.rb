require 'uuid'
require 'active_model'
require 'virtus'

class Imperator::Command
  include ActiveModel::Validations
  extend ActiveModel::Callbacks
  include Virtus

  if defined? ActiveModel::Serializable
    include ActiveModel::Serializable::JSON
    include ActiveModel::Serializable::XML
  else
    include ActiveModel::Serializers::JSON
    include ActiveModel::Serializers::Xml
  end

  define_model_callbacks :create, :perform, :initialize

  attribute :id, String, :default => proc { UUID.generate }
  attribute :object, Object

  def self.action(&block)
    define_method(:action, &block)
  end

  alias_method :params, :attributes

  def self.attributes_for clazz, options = {}
    raise NotImplementedError
  end

  def to_s
    str = "Command: #{id}"
    str << " - #{object}" if object
    str
  end

  def as_json(*args)
    attributes.as_json(*args)
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

  # @abstract
  def action
    raise NoMethodError.new("Please define #action for #{self.class.name}")
  end

  def perform
    run_callbacks(:perform) { action }
    self
  end
end
