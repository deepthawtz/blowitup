worker_processes 2

preload_app true

working_directory "/home/deploy/blowitup"

listen "/tmp/unicorn-blowitup.sock", :backlog => 1024
listen 9090, :tcp_nopush => true

timeout 30

pid "/home/deploy/blowitup/unicorn.pid"

stderr_path "/home/deploy/blowitup/log/unicorn-error.log"
stdout_path "/home/deploy/blowitup/log/unicorn-access.log"

# REE
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_fork do |server,worker|
  # setup mongo here?
end

after_fork do |server, worker|
end
