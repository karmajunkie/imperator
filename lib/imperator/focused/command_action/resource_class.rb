class Imperator::Focused::CommandAction < FocusedAction
  def resource_class_name
    self.class.resource_class_name
  end

  def resource_class
    self.class.resource_class
  end

  class << self
    attr_writer :resource_class

    def resource_class_name
      resource_class.to_s.underscore
    end

    # extracted from https://github.com/josevalim/inherited_resources/blob/master/lib/inherited_resources/class_methods.rb
    def resource_class
      # First priority is the namespaced model, e.g. User::Group
      self.resource_class ||= begin
        namespaced_class = self.name.sub(/Controller/, '').singularize
        namespaced_class.constantize
      rescue NameError
        nil
      end

      # Second priority is the top namespace model, e.g. EngineName::Article for EngineName::Admin::ArticlesController
      self.resource_class ||= begin
        namespaced_classes = self.name.sub(/Controller/, '').split('::')
        namespaced_class = [namespaced_classes.first, namespaced_classes.last].join('::').singularize
        namespaced_class.constantize
      rescue NameError
        nil
      end

      # Third priority the camelcased c, i.e. UserGroup
      self.resource_class ||= begin
        camelcased_class = self.name.sub(/Controller/, '').gsub('::', '').singularize
        camelcased_class.constantize
      rescue NameError
        nil
      end

      # Otherwise use the Group class, or fail
      self.resource_class ||= begin
        class_name = self.controller_name.classify
        class_name.constantize
      rescue NameError => e
        raise unless e.message.include?(class_name)
        nil
      end
    end        
  end
end
