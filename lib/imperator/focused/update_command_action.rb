require 'imperator/focused/command_action'

class Imperator::Focused::UpdateCommandAction < CommandAction
  protected

  delegate :invalid_path, :to => :edit_path

  def edit_path
    "edit_#{resource_class_name}_path"
  end
end

# create convenience constant
UpdateCommandAction = Imperator::Focused::UpdateCommandAction