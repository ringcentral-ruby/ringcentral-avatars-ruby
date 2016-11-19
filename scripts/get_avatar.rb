#!ruby

require 'ringcentral_sdk'
require 'ringcentral-avatars'
require 'multi_json'
require 'pp'

# Set your credentials in the .env file
# Use the rc_config_sample.env.txt file as a scaffold

config = RingCentralSdk::REST::Config.new.load_dotenv

client = RingCentralSdk::REST::Client.new
client.set_app_config config.app
client.authorize_user config.user

file = '_my_avatar.png'

res1 = client.http.get 'account/~/extension/~/'

pp res1.body['profileImage']
puts res1.status

res2 = client.http.get res1.body['profileImage']['uri']
puts res2.status

File.open(file, 'wb') do |fh|
  fh.puts res2.body
end
