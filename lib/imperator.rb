require "imperator/version"
require 'imperator/errors'
require 'imperator/command'
require 'imperator/command/restfull'
require 'imperator/command/class_factory'

require 'imperator/focused' if defined?(FocusedController)
require 'imperator/mongoid' if defined?(Mongoid)


module Imperator
  # Your code goes here...
end
