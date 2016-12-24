require 'ringcentral-avatars/creator'

module RingCentral
  module Avatars
    VERSION = '0.4.1'.freeze

    class << self
      def new(client, opts = {})
        RingCentral::Avatars::Creator.new client, opts
      end
    end
  end
end
