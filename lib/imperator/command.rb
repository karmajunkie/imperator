require 'virtus'
class Imperator::Command
  include Virtus
  extend Imperator::Config

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
    check_valid_command
    self.commit
  end

  def commit(options = nil)
    self.class.background_processor.commit(self, options || self.class.background_options)
  end

  def initialize(*)
    super
  end

  def self.load(command_string)
   self.new(JSON.parse(command_string))
  end

  def self.background(options = {})
    @background_options = options
  end

  def self.background_options
    @background_options 
  end

  def self.background_processor
    @background_processor ||= superclass.background_processor || Imperator::NullBackgroundProcessor
  end

  def self.background_processor=(backgrounder)
    @background_processor = backgrounder
  end

  def load(command_string)
    self.attributes = HashWithIndifferentAccess.new(JSON.parse(command_string))
  end

  def perform!
    check_valid_command
    self.perform
  end

  # @abstract
  def action
    raise NoMethodError.new("Please define #action for #{self.class.name}")
  end

  def perform
    action
  end

  private
  def check_valid_command
    if self.respond_to?(:valid?)
      raise Imperator::InvalidCommandError.new "Command was invalid" unless valid?
    end
  end

end
