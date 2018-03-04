require 'rubocop/rake_task'

current_directory = File.dirname(__FILE__)

RuboCop::RakeTask.new

namespace :cloudformation do
  desc 'Check CloudFormation syntax'
  task :validate do
    sh "cd #{current_directory}/cloudformation; bundle exec ./ntppool_deployment.rb validate --region us-west-2"
  end

  task :rubocop do
    sh "rubocop -SD cloudformation"
  end
end

namespace :chef do
  desc 'Check chef syntax'
  task :rubocop do
    sh "rubocop -SD chef"
  end
end

task default: %i[rubocop cloudformation:validate]

task syntax: %i[rubocop cloudformation:validate]
