require 'avatarly'
require 'faraday'
require 'ringcentral_sdk'
require 'tempfile'

module RingCentral
  module Avatars
    class Creator
      DEFAULT_SIZE = 600

      attr_accessor :client
      attr_accessor :extensions

      def initialize(client)
        @client = client
        load_extensions
      end

      ##
      # Convenience method for creating default avatars for all extensions
      # Defaults to not overwriting existing avatars
      def create_defaults(opts = {})
        opts[:overwrite] = false
        create_all opts
      end

      ##
      # Convenience method for creating avatars for all extensions
      # Defaults to overwriting existing avatar
      def create_all(opts = {})
        opts[:overwrite] = true unless opts.key?(:overwrite)
        @extensions.extensions_hash.each do |ext_id, ext|
          create_avatar ext, opts
        end
        load_extensions
      end

      ##
      # Convenience method for creating avatar for authorized extension
      # Defaults to not overwriting existing avatar
      def create_mine(opts = {})
        res = @client.http.get 'account/~/extension/~'
        create_avatar res.body, opts
        load_extensions
      end

      ##
      # Create the avatar for the extension.
      # Defaults to not overwriting existing avatar
      def create_avatar(ext, opts = {})
        opts[:overwrite] = false unless opts.key?(:overwrite)
        return if has_avatar(ext) && !opts[:overwrite]
        avatar_temp = get_avatar_tmp_file ext
        url = "account/~/extension/#{ext['id']}/profile-image"
        image = Faraday::UploadIO.new(avatar_temp.path, 'image/png')
        @client.http.put url, image: image
      end

      ##
      # Determines if extension has an existing avatar
      # Checks by looking ofr the presence of the `etag` property
      def has_avatar(ext)
        return ext['profileImage'].key?('etag') ? true : false
      end

      def get_avatar_tmp_file(ext)
        avatar_blob = Avatarly.generate_avatar(ext['name'], size: DEFAULT_SIZE)
        avatar_temp = Tempfile.new(['avatar', '.png'])
        avatar_temp.binmode
        avatar_temp.write(avatar_blob)
        avatar_temp.flush
        avatar_temp
      end

      def load_extensions
        @extensions = RingCentralSdk::REST::Cache::Extensions.new client
        @extensions.retrieve_all
      end

      ##
      # Returns a list of avatar URLs which can be useful for testing purposes
      # Adding the current access token is optional
      def avatar_urls(include_token = false)
        urls = []
        @extensions.extensions_hash.keys.sort.each do |ext_id|
          ext = @extensions.extensions_hash[ext_id]
          urls.push avatar_url(ext, include_token)
        end
        return urls
      end

      def my_avatar_url(include_token = false)
        res = @client.http.get 'account/~/extension/~'
        avatar_url(res.body, include_token)
      end

      def avatar_url(ext, include_token = false)
        token = @client.token.to_hash[:access_token]
        url = ext['profileImage']['uri']
        url += "?access_token=#{token}" if include_token
        return url
      end
    end
  end
end