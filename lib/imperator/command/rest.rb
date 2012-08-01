class Imperator::Command
  module Rest
    attribute :object_class, Object

    def self.create_new &block
      action do    
        object_class.create attribute_set if object_class
        yield
      end    
    end

    def self.update &block
      action do    
        find_object.update_attributes attribute_set if find_object
        yield
        rescue e: Imperator::ResourceNotFoundError
          on_error e
      end    
    end

    def self.delete &block
      action do    
        find_object.delete
        yield
      end    
    end

    def self.on_error &block
      define_method(:on_error, &block)
    end

    def self.for_class clazz
      object_class = clazz
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
