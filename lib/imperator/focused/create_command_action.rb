require 'imperator/focused/command_action'

class Imperator
  module Focused
    class CreateCommandAction < CommandAction

      protected

      delegate :invalid_path, :to => :new_path

      def new_path
        "new_#{resource_class_name}_path"
      end
    end
  end
end

# create convenience constant
CreateCommandAction = Imperator::Focused::CreateCommandAction