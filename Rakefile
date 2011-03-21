require "rake/testtask"

task :default => :test
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/test_*.rb"]
end

desc "load app into IRB"
task :console do
  exec "irb -I . -rblowitup"
end
