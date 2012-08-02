class Imperator::Command
  module MethodFactory
    def command_method command, options = {}
      define_method "#{command}_command" do
        instance_var = "@#{command}_command"
        unless instance_variable_get(instance_var)        
          clazz = "#{command.to_s.camelize}Command".constantize        
          instance_variable_set instance_var, clazz.new options.merge(initiator: self) 
        end
      end
    end

    extend self
  end
end