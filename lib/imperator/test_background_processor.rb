class Imperator::TestBackgroundProcessor
  @commits = []
  class << self
    attr_accessor :commits
    attr_accessor :commit_mode
  end

  def self.commit(command, options = nil) 
    @commits << command
    command.perform! if self.commit_mode == :immediate
  end
end
