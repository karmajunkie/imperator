class Imperator::NullBackgroundProcessor
  def self.commit(command, options = nil)
    command.perform
  end
end
