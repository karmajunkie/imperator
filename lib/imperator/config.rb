module Imperator::Config
  def configure(&block)
    raise ArgumentError.new("must supply configuration block") unless block_given?
    yield self
  end
end
