def ruby(file, args=nil)
  puts "Running #{file}.rb"
  puts `ruby #{file}.rb #{args}`
  puts
end

desc "Fetch tweets, then show reports"
task :default do
  ruby :mytweets
  ruby :mentions, '--limit 10'
  ruby :replies, '--limit 10'
end