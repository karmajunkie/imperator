require 'virtus'
class Imperator::Command
  include Virtus

  def self.action(&block)
    define_method(:action, &block)
  end

  alias_method :params, :attributes

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
    super
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
    action
  end

end
