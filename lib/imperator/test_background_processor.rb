class Imperator::TestBackgroundProcessor
  @commits = []
  class << self
    attr_accessor :commits
  end

  def self.commit(command)
    @commits << command
  end
end
