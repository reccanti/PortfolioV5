require 'json'

desc 'Test Rake task'
task :hello do
  puts "Hello from Rake!"
end

desc 'generate JSON'
task :makeJSON do
  test_json = {:hello => "world"}
  File.open("_data/test.json", "w") do |f|
    f.write(JSON.pretty_generate(test_json))
    puts JSON.pretty_generate(test_json)
  end
end
