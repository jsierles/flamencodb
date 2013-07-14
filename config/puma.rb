#!/usr/bin/env puma

application_path = '/home/app/letrasflamencas'

directory application_path

environment :production

daemonize true

pidfile "#{application_path}/shared/tmp/pids/puma.pid"

state_path "#{application_path}/shared/tmp/puma.state"

stdout_redirect "#{application_path}/shared/log/puma.stdout.log", "#{application_path}/shared/log/puma.stderr.log", true

threads 0, 16

bind "/tmp/rails.sock"

workers 2

on_worker_boot do
  ActiveRecord::Base.establish_connection
end