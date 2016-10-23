require 'ringcentral-avatars/creator'

module RingCentralAvatars
  VERSION = '0.0.1'

  class << self
    def new(client)
      RingCentralAvatars::Creator.new client
    end
  end
end
