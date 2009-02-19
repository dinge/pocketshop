set :application, "dingbank"

set :user, 'railshost'
set :use_sudo, false

set :scm, :git 
set :repository, "file://." 
set :deploy_via, :copy 
set :copy_strategy, :export
set :branch, "with_neo4j"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"


role :app, "roboterliebe.de"
role :web, "roboterliebe.de"
role :db,  "roboterliebe.de", :primary => true