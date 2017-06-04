require 'active_model'
require 'virtus'
class Imperator::Command
  include ActiveModel::Validations
  extend ActiveModel::Callbacks
  include Virtus.model

  if defined? ActiveModel::Serializable
    include ActiveModel::Serializable::JSON
    include ActiveModel::Serializable::XML
  else
    include ActiveModel::Serializers::JSON
    include ActiveModel::Serializers::Xml
  end

  define_model_callbacks :create, :perform, :initialize

  def self.action(&block)
    define_method(:action, &block)
  end

  alias params attributes

  def as_json(*args)
    attributes.as_json(*args)
  end

  def persisted?
    false
  end

  def commit!
    raise Imperator::InvalidCommandError, 'Command was invalid' unless valid?
    commit
  end

  def commit
    # TODO: background code for this
    perform
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
    new(JSON.parse(command_string))
  end

  def load(command_string)
    self.attributes = HashWithIndifferentAccess.new(JSON.parse(command_string))
  end

  def perform!
    raise InvalidCommandError, 'Command was invalid' unless valid?
    perform
  end

  # @abstract
  def action
    raise NoMethodError, "Please define #action for #{self.class.name}"
  end

  def perform
    run_callbacks(:perform) { action }
  end
end
