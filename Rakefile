require "bundler/gem_tasks"

# Bootstrap an IRB session
desc "Load an irb shell with GradFlickr bootstrapped"
task :shell do
  exec "irb -I #{File.expand_path('../lib', __FILE__)} -r birdlense"
end

