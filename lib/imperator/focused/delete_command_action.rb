require 'imperator/focused/command_action'

class Imperator::Focused::DeleteCommandAction < CommandAction
  protected

  delegate :invalid_path, :to => :index_path

  def index_path
    "#{resource_class_name.pluralize}_path"
  end
end

# create convenience constant
DeleteCommandAction = Imperator::Focused::DeleteCommandAction