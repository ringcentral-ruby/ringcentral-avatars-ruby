require 'avatarly'
require 'faraday'
require 'ringcentral_sdk'
require 'tempfile'

module RingCentralAvatars
  class Creator
    DEFAULT_SIZE = 600

    attr_accessor :client
    attr_accessor :extensions

    def initialize(client)
      @client = client
      load_extensions
    end

    def create_all(overwrite = false)
      @extensions.extensions_hash.each do |ext_id, ext|
        create_avatar ext, overwrite
      end
      load_extensions
    end

    def create_mine(overwrite = false)
      res = @client.http.get 'account/~/extension/~'
      create_avatar res.body, overwrite
      load_extensions
    end

    def create_avatar(ext, overwrite = false)
      return if has_avatar(ext) && !overwrite
      avatar_temp = get_avatar_tmp_file ext
      url = "account/~/extension/#{ext['id']}/profile-image"
      image = Faraday::UploadIO.new(avatar_temp.path, 'image/png')
      @client.http.put url, image: image
    end

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