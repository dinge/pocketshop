set :application, "dingbank"

set :user, 'railshost'
set :use_sudo, false

set :scm, :git
set :repository, "file://."
set :deploy_via, :copy
# set :copy_strategy, :export
set :branch, "master"
set :git_enable_submodules, 1

set :deploy_to, "/home/railshost/apps/#{application}"

role :app, "roboterliebe.de"
role :web, "roboterliebe.de"
role :db,  "roboterliebe.de", :primary => true


# check more at
# http://github.com/guides/deploying-with-capistrano
# set :deploy_via, :remote_cache
# set :git_shallow_clone, 1

# based on http://blog.raphinou.com/2008/12/capistrano-deployment-for-jetty-rails.html
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
    run "cd #{current_path} && #{try_runner} nohup script/start_jetty", :pty => true
  end
end