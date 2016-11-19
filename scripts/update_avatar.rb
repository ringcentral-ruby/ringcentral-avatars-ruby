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

avatars = RingCentral::Avatars.new client
res = avatars.create_mine overwrite: true # overwrite existing user avatar
puts res.status
