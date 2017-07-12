#!ruby

require 'logger'
require 'optparse'
require 'ringcentral_sdk'
require 'ringcentral-avatars'
require 'multi_json'
require 'pp'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: example.rb [options]'

  opts.on('-a', '--all', 'Update all users') do |v|
    options[:all] = v
  end
  opts.on('-o', '--overwrite', 'Overwrite existing avatars') do |v|
    options[:overwrite] = v
  end
end.parse!

# Set your credentials in the .env file
# Use the rc_config_sample.env.txt file as a scaffold

client = RingCentralSdk::REST::Client.new do |config|
  config.load_env = true
  config.logger = Logger.new STDOUT
  config.logger.level = Logger::DEBUG
  config.retry = true if options.key? :all
end

pp client.token.to_hash

avatars = RingCentral::Avatars.new client

if options.key? :all
  avatars.create_all overwrite: options[:overwrite]
else
  res = avatars.create_mine overwrite: options[:overwrite] # overwrite existing user avatar
  unless res.nil?
    puts res.class.name
    puts res.status
  end
end

puts 'DONE'
