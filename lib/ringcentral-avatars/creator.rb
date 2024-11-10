require 'avatarly'
require 'chunky_png'
require 'ruby_identicon'

require 'faraday'
require 'faraday_middleware-request-retry'
require 'logger'
require 'mime/types'
require 'ringcentral_sdk'
require 'tempfile'

module RingCentral
  module Avatars
    class Creator
      DEFAULT_SIZE = 600
      DEFAULT_FORMAT = 'png'.freeze
      PNG_DEFAULT_METADATA = {
        'Description' => 'RingCentral Default Avatar'
      }.freeze

      attr_accessor :avatar_opts, :avatars, :client, :extensions, :png_metadata, :retry

      ##
      # Requires RingCentralSdk instance
      # `:avatar_opts` is optional to pass-through options for Avatarly
      def initialize(client, opts = {})
        @client = client
        if !opts.key?(:initials_opts) && opts.key?(:avatar_opts)
          opts[:initials_opts] = opts[:avatar_opts]
        end
        if opts.key? :png_metadata
          opts[:png_metadata] = PNG_DEFAULT_METADATA.merge(opts[:png_metadata])
        else
          opts[:png_metadata] = PNG_DEFAULT_METADATA
        end
        opts[:logger] = @client.config.logger
        @retry = opts.key?(:retry) && opts[:retry] ? true : false
        opts[:retry] = @retry
        @avatars = RingCentral::Avatars::MultiAvatar.new opts
        @retry_util = FaradayMiddleware::Request::RetryUtil.new logger: client.config.logger
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
        @extensions.extensions_hash.each do |_ext_id, ext|
          create_avatar ext, opts
        end
        load_extensions
      end

      ##
      # Convenience method for creating avatar for authorized extension
      # Defaults to not overwriting existing avatar
      def create_mine(opts = {})
        try_req = true
        while try_req
          res_ext = @client.http.get 'account/~/extension/~'
          try_req = retry_status res_ext
        end
        res_avt = create_avatar res_ext.body, opts
        res_avt
      end

      ##
      # Create the avatar for the extension.
      # Defaults to not overwriting existing avatar
      def create_avatar(ext, opts = {})
        opts[:overwrite] = false unless opts.key?(:overwrite)
        if avatar?(ext) && !opts[:overwrite]
          return nil
        end
        url = "account/~/extension/#{ext['id']}/profile-image"
        res_avt = nil
        try_req = true
        while try_req
          image = @avatars.avatar_faraday_uploadio ext['name']
          res_avt = @client.http.put url, image: image
          try_req = retry_status res_avt
        end

        res_avt
      end

      def retry_status(res)
        return false unless @retry
        @retry_util.retry_status(res.status, res.headers['Retry-After'])
      end

      ##
      # Determines if extension has an existing avatar
      # Checks by looking for the presence of the `etag` property
      def avatar?(ext)
        ext['profileImage'].key?('etag') ? true : false
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
    end
  end
end

module RingCentral
  module Avatars
    class MultiAvatar
      DEFAULT_STYLE = 'initials'.freeze
      AVATARLY_DEFAULTS = {
        size: 600,
        format: 'png'
      }.freeze
      IDENTICON_DEFAULTS = {
        grid_size: 5,
        square_size: 70,
        background_color: 0xffffffff
      }.freeze
      IDENTICON_DEFAULT_FORMAT = 'png'.freeze

      def initialize(opts = {})
        @avatarly_opts =  inflate_avatarly_opts opts[:initials_opts]
        @identicon_opts = inflate_identicon_opts opts[:identicon_opts]
        @style = opts.key?(:style) ? opts[:style] : DEFAULT_STYLE
        @png_metadata = opts.key?(:png_metadata) ? opts[:png_metadata] : {}
        @logger = opts.key?(:logger) ? opts[:logger] : Logger.new(STDOUT)
      end

      def inflate_avatarly_opts(avatarly_opts = {})
        avatarly_opts = {} unless avatarly_opts.is_a? Hash
        AVATARLY_DEFAULTS.merge avatarly_opts
      end

      def inflate_identicon_opts(identicon_opts = {})
        identicon_opts = {} unless identicon_opts.is_a? Hash
        IDENTICON_DEFAULTS.merge identicon_opts
      end

      def avatar_blob(text, style = nil)
        style = @style if style.nil?
        blob = style == 'initials' \
          ? Avatarly.generate_avatar(text, @avatarly_opts) \
          : RubyIdenticon.create(text, @identicon_opts)
        inflate_avatar_blob_png blob
      end

      def inflate_avatar_blob_png(blob)
        return blob unless avatar_format == 'png' && @png_metadata
        img = ChunkyPNG::Image.from_blob blob
        img.metadata = @png_metadata
        img.to_blob
      end

      def avatar_temp_file(text, style = nil)
        blob = avatar_blob text, style
        file = Tempfile.new ['avatar', avatar_extension]
        file.binmode
        file.write blob
        file.flush
        file
      end

      def avatar_faraday_uploadio(text, style = nil)
        file = avatar_temp_file text, style
        @logger.debug "Building Avatar Temp File: #{file.path}"
        Faraday::UploadIO.new file.path, avatar_mime_type
      end

      def avatar_format
        @style == 'initials' ? @avatarly_opts[:format] : IDENTICON_DEFAULT_FORMAT
      end

      def avatar_mime_type
        types = MIME::Types.type_for avatar_format
        if types.empty?
          raise "Unknown avatar format: #{avatar_format}"
        end
        types[0].to_s
      end

      def avatar_extension
        ".#{avatar_format}"
      end
    end
  end
end
