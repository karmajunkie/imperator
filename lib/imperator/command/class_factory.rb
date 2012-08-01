class Imperator::Command
  # http://johnragan.wordpress.com/2010/02/18/ruby-metaprogramming-dynamically-defining-classes-and-methods/
  class ClassFactory
    class << self
      def use &block
        yield self
      end

      # Usage:
      # Imperator::Command::ClassFactory.create :update, Post, parent: Imperator::Mongoid::Command do
      #   ..
      # end
      def create action, model, options = {}, &block
        parent = options[:parent] || Imperator::Command
        clazz = Class.new parent do
          attributes_for(model, :except => options[:except]) if options[:auto_attributes]
          yield
        end
        Kernel.const_set "#{action}#{model}Command", clazz
      end

      # Usage:
      # Imperator::Command::ClassFactory.create_rest :all, Post, parent: Imperator::Mongoid::Command do
      #   ..
      # end
      def create_rest action, model, options = {}, &block
        options.reverse_merge! default_options
        parent = options[:parent] || default_rest_class
        create_rest_all(model, options = {}, &block) and return if action.to_sym == :all
        if rest_actions.include? action.to_sym        
          send "create_rest_#{action}", model, options, &block
        else
          raise ArgumentError, "Not a supported REST action. Must be one of #{rest_actions}, was #{action}"
        end
      end

      attr_writer :default_rest_class

      def default_rest_class
        @default_rest_class ||= Imperator::Command::Restfull
      end

      attr_writer :default_options

      def default_options
        @default_options ||= {}
      end


      protected

      def rest_actions
        [:new, :update, :delete]
      end

      def create_rest_new model, options = {}, &block
        create :update, model, options do
          update
          yield
        end
      end

      def create_rest_update model, options = {}, &block
        create :update, model, options do          
          update
          yield
        end
      end

      def create_rest_delete model, options = {}, &block
        create :delete, model, options do          
          delete
          yield
        end
      end

      def create_rest_all model, options = {}, &block
        rest_actions.each do |action| 
          send "create_rest_#{action}", model, options, &block
        end
      end
    end
  end
end

# Global macro methods

def create_command action, model, options = {}, &block
  Imperator::Command::ClassFactory.create action, model, options = {}, &block
end

def create_rest_command action, model, options = {}, &block
  Imperator::Command::ClassFactory.create_rest action, model, options = {}, &block
end
