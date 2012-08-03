[:create, :update, :delete].each do |action|
  require "imperator/focused/#{action}_command_action"
end