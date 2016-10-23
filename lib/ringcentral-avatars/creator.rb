require 'avatarly'
require 'faraday'
require 'mime/types'
require 'ringcentral_sdk'
require 'tempfile'

module RingCentral
  module Avatars
    class Creator
      DEFAULT_SIZE = 600
      DEFAULT_FORMAT = 'png'

      attr_accessor :avatar_opts
      attr_accessor :client
      attr_accessor :extensions

      ##
      # Requires RingCentralSdk instance
      # `:avatar_opts` is optional to pass-through options for Avatarly
      def initialize(client, opts = {})
        @client = client
        @avatar_opts = build_avatar_opts opts[:avatar_opts]
        load_extensions
      end

      def build_avatar_opts(avatar_opts = {})
        avatar_opts = {} unless avatar_opts.is_a? Hash
        unless avatar_opts.key? :size
          avatar_opts[:size] = DEFAULT_SIZE
        end
        unless avatar_opts.key? :format
          avatar_opts[:format] = DEFAULT_FORMAT
        end
        return avatar_opts
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
        res_ext = @client.http.get 'account/~/extension/~'
        res_av = create_avatar res_ext.body, opts
        load_extensions
        res_av
      end

      ##
      # Create the avatar for the extension.
      # Defaults to not overwriting existing avatar
      def create_avatar(ext, opts = {})
        opts[:overwrite] = false unless opts.key?(:overwrite)
        return if has_avatar(ext) && !opts[:overwrite]
        avatar_temp = get_avatar_tmp_file ext
        url = "account/~/extension/#{ext['id']}/profile-image"
        image = Faraday::UploadIO.new avatar_temp.path, avatar_mime_type
        @client.http.put url, image: image
      end

      ##
      # Determines if extension has an existing avatar
      # Checks by looking for the presence of the `etag` property
      def has_avatar(ext)
        ext['profileImage'].key?('etag') ? true : false
      end

      def get_avatar_tmp_file(ext)
        avatar_blob = Avatarly.generate_avatar(ext['name'], @avatar_opts)
        avatar_temp = Tempfile.new(['avatar', avatar_extension])
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
      def avatar_urls(opts = {})
        opts[:include_token] = false unless opts.key? :include_token
        urls = []
        @extensions.extensions_hash.keys.sort.each do |ext_id|
          ext = @extensions.extensions_hash[ext_id]
          urls.push avatar_url(ext, opts)
        end
        urls
      end

      def my_avatar_url(opts = {})
        opts[:include_token] = false unless opts.key? :include_token
        res = @client.http.get 'account/~/extension/~'
        avatar_url(res.body, opts)
      end

      def avatar_url(ext, opts = {})
        opts[:include_token] = false unless opts.key? :include_token
        token = @client.token.to_hash[:access_token]
        url = ext['profileImage']['uri']
        url += "?access_token=#{token}" if opts[:include_token]
        url
      end

      def avatar_mime_type
        types = MIME::Types.type_for @avatar_opts[:format]
        if types.length == 0
          raise "Unknown avatar format: #{@avatar_opts[:format]}"
        end
        types[0].to_s
      end

      def avatar_extension
        ".#{@avatar_opts[:format]}"
      end
    end
  end
end