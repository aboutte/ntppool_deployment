require 'rubocop/rake_task'

current_directory = File.dirname(__FILE__)

RuboCop::RakeTask.new

namespace :cloudformation do
  desc 'Check CloudFormation syntax'
  task :syntax do
    sh "cd #{current_directory}/cloudformation; bundle exec ./ntppool_deployment.rb validate --region us-west-2"
  end
end



task default: %i(rubocop cloudformation:syntax)
