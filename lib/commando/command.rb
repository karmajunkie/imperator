class Commando::Command
  include ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization
  include ActiveModel::Serializers::JSON


  attr_accessor :params
  cattr_accessor :commit_mode

  def initialize(params={})
    self.params = HashWithIndifferentAccess.new params.dup
    self.params[:id] = UUIDTools::UUID.timestamp_create.to_s if self.params[:id].nil?
  end

  def valid?
    true
  end

  def attributes
    params
  end

  def persisted?
    false
  end

  def commit!
    raise Commando::InvalidCommandError.new "Command was invalid" unless valid?
    self.commit
  end

  def commit
    #TODO: background code for this
    self.perform
  end

  def dump
    params.to_json
  end

  def self.load(command_string)
    self.new(JSON.parse(command_string))
  end

  def load(command_string)
    self.params = HashWithIndifferentAccess.new(JSON.parse(command_string))
  end

  def perform!
    raise InvalidCommandError.new "Command was invalid" unless valid?
    self.perform
  end

  def perform
    raise "You need to override #perform in #{self.class.name}"
  end

  def id
    params[:id]
  end

  def method_missing(method, *args)
    method_root = method.to_s.gsub(/=$/, "")
    if params.has_key?(method_root)
      if method.to_s[/=$/]
        self.params[method_root] = args.first
      else
        self.params[method]
      end
    else
      super
    end
  end
end
