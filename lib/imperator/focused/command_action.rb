require 'imperator/focused/command_action/class_methods'
require 'imperator/focused/command_action/resource_class'

class Imperator::Focused::CommandAction < FocusedAction
  def run
    command.valid? ? perform_valid : perform_invalid
  end

  def valid
    command.perform
    valid_redirect
  end

  def invalid
    invalid_render
  end

  protected

  def valid_redirect
    redirect_to valid_redirect_path
  end

  def invalid_render
    render send(invalid_path, command.object)
  end

  def invalid_path
    raise NotImplementedError, "Must be implemented by subclass"
  end

  def valid_redirect_path
    raise NotImplementedError, "Must be implemented by subclass"
  end

  def action
    self.class.name.underscore
  end

  def flash_msg msg, type = :notice
    flash[type.to_sym] = msg
  end

  def command
    @command ||= default_command
  end

  def default_command
    command_class.new object_hash
  end

  def object_hash
    send("#{resource_class_name}_hash")
  end

  def command_class
    @command_class ||= "#{action.to_s.camelize}#{resource_class_name}Command".constantize
  end
end

# create convenience constant
CommandAction = Imperator::Focused::CommandAction

require 'imperator/focused/command_action/class_methods'
require 'imperator/focused/command_action/resource_class'

class Imperator::Focused::CommandAction < FocusedAction
  extend ActiveSupport::Concern

  # generates fx #post_hash method for PostController
  define_method "#{resource_class_name}_hash" do
    params[resource_class.to_sym]   
  end    
end