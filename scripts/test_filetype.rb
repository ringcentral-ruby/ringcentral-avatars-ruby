#!ruby

require 'faraday'
require 'mime/types'
require 'optparse'
require 'ringcentral_sdk'
require 'multi_json'
require 'pp'

# Usage: test_filetype.rb --filetype=jpg

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: example.rb --filetype=TYPE'

  opts.on('-f', '--filetype=TYPE', 'Filetype (png, jpg, gif)') do |v|
    options[:filetype] = v.downcase
  end
end.parse!

file = "test_filetype_#{options[:filetype]}.#{options[:filetype]}"

unless File.exist? file
  raise "File does not exist: #{file}"
end

client = RingCentralSdk::REST::Client.new do |config|
  config.load_env = true
end

types = MIME::Types.type_for options[:filetype]

faradayio = Faraday::UploadIO.new file, types[0]

url = 'account/~/extension/~/profile-image'

res1 = client.http.put url, image: faradayio

puts res1.status

if res1.status >= 400
  raise "Image Upload Failed with Status: #{res.status}"
end

res2 = client.http.get 'account/~/extension/~'

pp res2.body
puts res2.status

puts 'DONE'
