RAILS_ENV = 'production'
ROOT      = "/home/app/letrasflamencas"
CURRENT   = File.expand_path(File.join(ROOT, %w{current}))
LOGS      = File.expand_path(File.join(ROOT, %w{shared log}))
PIDS      = File.expand_path(File.join(ROOT, %w{shared tmp pids}))

Eye.config do
  logger "#{LOGS}/eye.log"
  logger_level Logger::ERROR
end

Eye.application :letras do
  env 'RAILS_ENV' => RAILS_ENV
  working_dir ROOT
  triggers :flapping, :times => 10, :within => 1.minute

  process :puma do
    daemonize true
    pid_file "#{PIDS}/puma.pid"
    stdall "#{LOGS}/#{RAILS_ENV}.log"

    start_command "bin/puma -b unix:/tmp/rails.sock --pidfile #{PIDS}/puma.pid --environment #{RAILS_ENV}"
    stop_command "kill -TERM {{PID}}"
    restart_command "kill -USR2 {{PID}}"

    start_timeout 15.seconds
    stop_grace 10.seconds
    restart_grace 10.seconds

    checks :cpu, :every => 30, :below => 80, :times => 3
    checks :memory, :every => 30, :below => 200.megabytes, :times => [3,5]
  end
end
