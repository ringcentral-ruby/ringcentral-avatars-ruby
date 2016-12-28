#!ruby

require 'ringcentral_sdk'
require 'ringcentral-avatars'
require 'multi_json'
require 'pp'

# Set your credentials in the .env file
# Use the rc_config_sample.env.txt file as a scaffold

client = RingCentralSdk::REST::Client.new do |config|
  config.load_env = true
end

file = '_my_avatar.png'

# Get user info
res1 = client.http.get 'account/~/extension/~/'
pp res1.body['profileImage']
puts res1.status

# Get profile image
res2 = client.http.get res1.body['profileImage']['uri']
puts res2.status

# Save profile image
File.open(file, 'wb') do |fh|
  fh.puts res2.body
end
