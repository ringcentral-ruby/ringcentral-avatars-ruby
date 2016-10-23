require 'ringcentral-avatars/creator'

module RingCentral
  module Avatars
    VERSION = '0.1.0'

    class << self
      def new(client)
        RingCentral::Avatars::Creator.new client
      end
    end
  end
end