require 'imperator/command/rest'

class Imperator::Command
  class RestFull < Imperator::Command
    include Imperator::Command::Rest
  end
end
