class Imperator::Focused::CommandAction < FocusedAction
  module ClassMethods
    [:run, :action, :valid, :invalid, :valid_redirect_path, :invalid_path].each do |name|
      define_method name do |&block|
        send(:define_method, name, &block)
      end
    end
  end
end