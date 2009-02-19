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