#!/usr/bin/env puma

application_path = '/home/app/letrasflamencas/current'

rackup "#{application_path}/config.ru"

directory application_path

environment 'production'

daemonize true

pidfile "#{application_path}/tmp/pids/puma.pid"

state_path "#{application_path}/tmp/puma.state"

stdout_redirect "#{application_path}/log/puma.stdout.log", "#{application_path}/log/puma.stderr.log", true

threads 0, 16

bind "unix:/tmp/rails.sock"

workers 2
