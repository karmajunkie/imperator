require 'imperator/mongoid/command'

module Imperator::Mongoid
  class RestCommand < Imperator::Command::Mongoid
    include Imperator::Command::Rest
  end
end
