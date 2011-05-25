# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
MarSprintDemo::Application.initialize!

MarSprintDemo::Application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.raise_delivery_errors = true
end  



