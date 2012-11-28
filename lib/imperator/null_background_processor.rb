class Imperator::NullBackgroundProcessor
  def self.commit(command)
    command.perform
  end
end
