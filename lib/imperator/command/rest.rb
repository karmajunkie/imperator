class Imperator::Command
  module Rest
    class << self
      attr_writer :object_class

      def create_action &block
        action do    
          object_class.create attribute_set if object_class
          yield
        end    
      end

      def update_action &block
        action do    
          find_object.update_attributes attribute_set if find_object
          yield
          rescue e: Imperator::ResourceNotFoundError
            on_error e
        end    
      end

      def delete_action &block
        action do    
          find_object.delete
          yield
        end    
      end

      def on_error &block
        define_method(:on_error, &block)
      end

      def for_class clazz
        @object_class = clazz
      end

      def object_class
        @object_class ||= filtered_class_name
      end

      protected

      # convert to underscore format, fx UpdatePostCommand becomes update_post_command
      # remove 'create', 'update' or 'delete' in the front of name: _post_command
      # then remove command at the back: _post_
      # then remove any '_': post
      def filtered_class_name
        self.class.name.underscore.sub(/^(create|update|delete)/, '').sub(/command$/, '').sub(/_/, '')
      end
    end

    def object_class
      self.class.object_class
    end

    def on_error exception
      raise Imperator::InvalidCommandError, "The Command #{self} caused an error: #{exception}"
    end

    def find_object
      object ||= object_class.find(self.id)
    rescue
      find_object_error
    end

    def find_object_error
      raise Imperator::ResourceNotFoundError, "The resource #{self.id} could not be found" 
    end
  end
end
