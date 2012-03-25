require 'yaml'

IronWorker.configure do |config|
  config.token = ENV['IRON_WORKER_TOKEN']
  config.project_id = ENV['IRON_WORKER_PROJECT_ID']

  #config.database = Rails.configuration.database_configuration[Rails.env] 
end