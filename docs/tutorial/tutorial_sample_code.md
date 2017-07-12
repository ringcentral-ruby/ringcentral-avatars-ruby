# RingCentral Default Avatar Tutorial

## Tutorial Code Samples

### Retrieving a list of users without images

```ruby
require 'ringcentral_sdk'
client = RingCentralSdk::REST::Client.new do |config|
  # config data
end
res = client.get account/~/extension
res.body['records'].each do |ext|
  # skip if user has an existing image
  next if ext['profileImage'].key?('etag')
  # create image and upload image
end
```

#### Example User Object

```json
{
  "uri": "https://platform.devtest.ringcentral.com/restapi/v1.0/account/11111111/extension/22222222",
  "id": 22222222,
  "extensionNumber": "102",
  "contact": {
    "firstName": "Alice"
    "businessPhone": "+6505550102"
  },
  "name": "Alice",
  "type": "User",
  "status": "Enabled",
  "permissions": {
    "admin": {
      "enabled": false
    },
    "internationalCalling": {
      "enabled": false
    }
  },
  "profileImage": {
    "uri": "https://media.devtest.ringcentral.com/restapi/v1.0/account/11111111/extension/22222222/profile-image",
    "etag": "0123456789abcdef0123456789abcdef",
    "contentType": "image/png",
    "lastModified": "2016-11-01T00:00:00.000Z",
    "scales": [
      {
        "uri": "https://media.devtest.ringcentral.com/restapi/v1.0/account/11111111/extension/22222222/profile-image/90x90"
      },
      {
        "uri": "https://media.devtest.ringcentral.com/restapi/v1.0/account/11111111/extension/22222222/profile-image/195x195"
      },
      {
        "uri": "https://media.devtest.ringcentral.com/restapi/v1.0/account/11111111/extension/22222222/profile-image/584x584"
      }
    ]
  }
}
```

Creating an Avatar

```ruby
# Using Initials
require 'avatarly'
blob = Avatarly.generate_avatar 'AZ'

# Using Identicons
require 'ruby_identicon'
blob = RubyIdenticon.create 'AZ'
```

Converting an Image Blob to a Faraday::UploadIO Object

```ruby
# Convert the blob to a Faraday::UploadIO object
file = Tempfile.new ['avatar', avatar_extension]
file.binmode
file.write blob
file.flush
fileio = Faraday::UploadIO.new file.path, 'image/png'

# post the image
client.http.put 'account/~/extension/profile-image', image: fileio
```

Putting it Together (Using the Gem)

```ruby
require 'ringcentral-avatars'
require 'ringcentral_sdk'

client = RingCentralSdk::REST::Client.new do |config|
  # ... params
  config.retry = true # retry throttled API calls
end

avatars = RingCentral::Avatars.new client
avatars.create_defaults
```


