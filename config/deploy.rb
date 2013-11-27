require 'fast_git_deploy'
require 'bundler/capistrano'
require 'capistrano-rbenv'

set :application, "letrasflamencas"
set :repository,  "git@github.com:jsierles/flamencodb.git"
set :user, "app"
set :deploy_to, "/home/app/letrasflamencas"
set :branch, "master"
set :rbenv_ruby_version, "2.0.0-p247"
set :use_sudo, false

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]
set :use_sudo, false

server 'tomaflamenco.com', :web, :app, :db

namespace :deploy do
  task :restart do
    run "kill -USR2 `cat #{shared_path}/tmp/pids/puma.pid`"
  end
end
