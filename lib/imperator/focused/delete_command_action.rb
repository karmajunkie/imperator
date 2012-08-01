require 'imperator/focused/command_action'

class Imperator
  module Focused
    class DeleteCommandAction < CommandAction

      protected

      delegate :invalid_path, :to => :index_path

      def index_path
        "#{resource_class_name.pluralize}_path"
      end
    end
  end
end

# create convenience constant
DeleteCommandAction = Imperator::Focused::DeleteCommandAction