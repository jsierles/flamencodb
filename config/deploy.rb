require 'fast_git_deploy'
require 'bundler/capistrano'
require 'capistrano-rbenv'

set :application, "letrasflamencas"
set :repository,  "git@github.com:jsierles/flamencodb.git"
set :user, "app"
set :deploy_to, "/home/app/letrasflamencas"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]

role :web, "ocean-1"
role :app, "ocean-1"
role :db,  "ocean-1"

