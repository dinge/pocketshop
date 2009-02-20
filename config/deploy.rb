set :application, "dingbank"

set :user, 'railshost'
set :use_sudo, false

set :scm, :git
set :repository, "file://."
set :deploy_via, :copy
# set :copy_strategy, :export
set :branch, "with_neo4j"
set :git_enable_submodules, 1

set :deploy_to, "/home/railshost/apps/#{application}"

role :app, "roboterliebe.de"
role :web, "roboterliebe.de"
role :db,  "roboterliebe.de", :primary => true



namespace :deploy do
  desc "Restarting jetty_rails"
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
  desc "Stopping jetty_rails"
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && script/stop_jetty", :pty => true
  end
  desc "Starting rails app with jetty_rails"
  task :start, :roles => :app do
    run "cd #{current_path} && #{try_runner} nohup script/spin", :pty => true
  end
end