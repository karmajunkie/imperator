class Imperator::TestBackgroundProcessor
  @commits = []
  class << self
    attr_accessor :commits
  end

  def self.commit(command, options = nil) 
    @commits << command
    command.perform!
  end
end
