require 'ringcentral-avatars/creator'

module RingCentral
  module Avatars
    VERSION = '0.2.1'

    class << self
      def new(client, opts = {})
        RingCentral::Avatars::Creator.new client, opts
      end
    end
  end
end