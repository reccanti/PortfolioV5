require 'json'
require 'dotenv/load'
require './tasks/googleSheet'

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

desc 'get info from a google sheet'
task :getSheetInfo do
  sheet = getSpreadsheetValues(ENV['SHEET_ID'], "Swipe Rogue", "A1:B")
  puts sheet
end
