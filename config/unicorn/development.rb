# Set your full path to application.
APP_PATH = "/vagrant/naturacast.com"

# Set unicorn options
worker_processes 10
preload_app true
timeout 120
#listen "/tmp/.impressions_unicorn_sock", :backlog => 64
listen "192.168.2.2:3000"

# Spawn unicorn master worker for user apps (group: apps)
#user 'deploy', 'deploy'

# Fill path to your app
working_directory APP_PATH

# Should be 'production' by default, otherwise use other env
rails_env = 'development'

# Log everything to one file
stderr_path "log/unicorn.log"
stdout_path "log/unicorn.log"

# Set master PID location
pid "#{APP_PATH}/tmp/pids/unicorn.pid"

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  old_pid = APP_PATH+"/tmp/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

#after_fork do |server, worker|
#  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
#
#  # Reset the memcache-based object store
#  Rails.cache.instance_variable_get(:@data).reset if Rails.cache.instance_variable_get(:@data).respond_to?(:reset)
#
#  #write unicorn workers pids for monit to monitor
#  port = 5500 + worker.nr
#  child_pid = server.config[:pid].sub('.pid', ".#{port}.pid")
#  system("echo #{Process.pid} > #{child_pid}")
#end

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{APP_PATH}/Gemfile"
end
