The Profile Image API and Default Images
========================================

The RingCentral Profile Image API is a powerful API that can be used to upload images that are used in the corporate address book both individually and administratively across users. Some popular use cases include:

1. Syncing images from Active Directory or Okta
2. Uploading images from mobile apps
3. Setting default images for users

For this article, we'll cover API basics and then discuss how to set default images using either user initials like Gmail/Office 365 or Identicons. 

We will cover:

1. API basics
  1. User profile image information
    1. Example user object
  2. Update user profile image
    1. Example request
  3. Subscribing for avatar updates
    1. Example request
    2. Example response
    3. Retrieving the user image
2. Default images recipe
  1. Getting a list of extensions without avatars
  2. Creating the default image
  3. Identifying auto-generated default images
  4. Wrapping it up
1. Notes
  2. Throttling

This article uses the Ruby language and leverages the community `ringcentral_sdk` SDK gem. It also presents code which is implemented in a similar way in the `ringcentral-avatars` Ruby gem.

## API basics

When working with the Profile API, there are a few basic APIs to use:

| method | endpoint | notes |
|--------|----------|-------|
| `GET` | `account/~/extension/~` | Get your own extension info with profile image information. |
| `GET` | `account/~/extension` | Get a list of extension with profile image information. |
| `PUT` | `account/~/extension/~/profile-image` | Update the user's profile image with a binary image file. |
| n/a | `account/~/extension` | Event filter for webhook and PubNub-based subscriptions |

### User profile image information

To retrieve the extension `profileImage` information for a user, retrieve the user's `account/~/extension/~` endpoint.

#### Example user object

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

### Update user profile image

To update an image make a `PUT` request to the user's `account/~/extension/~/profile-image` endpoint using `multipart/formdata` and the `image` attribute. 

#### Example request

Using the Ruby SDK, you can do the following:

```ruby
url = 'account/~/extension/~/profile-image'
file = Faraday::UploadIO.new '/path/to/myimage.png', 'image/png'

client.http.put url, image: file
```

### Subscribing for avatar updates

Client applications can subscribe for updates by using the Subscription API using either webhooks or PubNub using the `account/~/extension` event filter. The app will be notified of changes in real time and can retrieve the relevant images. This type of client-side update is implemented in the RingCentral for Desktop softphone app.

#### Example request

```ruby
# Create an observable subscription and add your observer
sub = client.create_subscription()
sub.subscribe([ "/restapi/v1.0/account/~/extension" ])
sub.add_observer MyObserver.new()
```

#### Example event

When a user's extension has changed for any reason, including, profile image updates, an event is fired that matches `account/~/extension` filter mentioned above with the following example format. Once you have the `extensionId` you can retrieve the user extension if to see if the `etag` has changed. If so, you can retrieve and update the image in your app.

```ruby
{
  "uuid":"11112222-0000-0000-0000-333344445555",
  "event":"/restapi/v1.0/account/11111111/extension",
  "timestamp":"2016-11-23T16:42:08.482Z",
  "subscriptionId":"11112222-1111-1111-1111-333344445555",
  "body": {
    "extensions":[
      {"extensionId":"22222222","eventType":"Update"}
    ]
  }
}
```

## Default images recipe

To create default images we want to do a few things:

1. Get a list of all extensions which do not have avatars
2. Create and upload default images for extensions

### Getting a list of extensions without avatars

To get a list of extensions without avatars, we need to get a list of all extensions and then filter for users without avatars. Since we do not have a way to do this server-side, we will retrieve all extensions and then filter client-side.

For the client-side filter, we will look for the `profileImage.etag` property. The `etag` property will not exist if there is no avatar which is an easy way to identify users that need a default avatar.

For example:

```ruby
require 'ringcentral_sdk'

client = RingCentralSdk.new ...
client.authorize ...

# Retrieve up to 1000 extensions
res = client.http.get do |req|
  req.url 'account/~/extension'
  req.params['perPage'] = 1000
end

# Filter for users without avatars
res.body['records'].each do |ext|
  next unless ext['profileImage'].key? 'etag'
end
```

The above will work with up to 1000 users. For over 1000 users, you will need to either follow the `navigation.nextPage` property yourself or use the `RingCentralSdk::REST::Cache::Extensions` gem. `RingCentral::Avatars` uses the extension cache similar to the following:

```ruby
# Load the cache
cache = RingCentralSdk::REST::Cache::Extensions.new client
cache.retrieve_all

# Cycle through the users
cache.extensions_hash.each do |ext_id, ext|
  next unless ext['profileImage'].key? 'etag'
end
```

### Creating the default image

The default image can be created in one of several ways that including:

1. User initials, like Gmail, Office 365, etc.
2. Identicons, like GitHub, Stack Overflow, Wordpress, etc.

Both of these are supported directly within `ringcentral-avatars` using `avatarly` and `ruby_identicon` to generate default images. They also both generate blobs:

```ruby
# Using Initials
require 'avatarly'
blob = Avatarly.generate_avatar 'AZ'

# Using Identicons
require 'ruby_identicon'
blob = RubyIdenticon.create 'AZ'
```

More information can be found for these particular libraries:

* [`avatarly`](https://rubygems.org/gems/avatarly)
* [`ruby_identicon`](https://rubygems.org/gems/ruby_identicon)

### Identifying auto-generated default images

Sometimes there may be a need to identify and overwrite only auto-generated images. The code above will not do this because auto-generated images will have an `etag` like user submitted images.

To resolve this, you can add a tag to the image itself which means each image will need to be retrieved and inspected. `ringcentral-avatars` supports setting PNG metadata attributes that can be used to identify default avatars. This can be done using [`chunky_png`](https://rubygems.org/gems/chunky_png):

```ruby
require 'chunky_png'

img = ChunkyPNG::Image.from_blob blob
img.metadata = { 'Description' => 'My Default Avatar' }
blob = img.to_blob
```

For JPEG, Exif can be implemented and is left as a future exercise.

### Wrapping it up

Much of this code has been implemented in the `ruby-avatars` gem and can be inspected in the gem's source code on GitHub. To use the gem to update your avatar, you can simply use the following commands:

```ruby
require 'ringcentral-avatars'
require 'ringcentral_sdk'

client = RingCentralSdk.new [...]

avatars = RingCentral::Avatars.new client                                # Default options
avatars = RingCentral::Avatars.new client, avatar_opts: {font_size: 275} # Avatarly options

avatars.create_defaults             # create default avatars only
avatars.create_all                  # create all avatars, overwriting existing avatars

avatars.create_mine                 # does not overwrite existing user avatar
avatars.create_mine overwrite: true # overwrite existing user avatar

avatars.create_avatar ext                  # create a default for an extension hash
avatars.create_avatar ext, overwrite: true # overwrite existing for an extension hash
```

## Notes

### Throttling

When retrieving and uploading many images, your application can be throttled if it is making API requests above the rate specified in your usage plan. To resolve this, you can make calls one at a time and examine the response status and headers. For example:

1. A `429` status will indicate your app is being throttled. It should wait the specified amount of seconds specified in the `Retry-After` header and then retry the request.
2. A `X-Rate-Limit-Remaining` of `0` will indicate that the app has used up its allotment of API calls for the window and should wait the amount of seconds specified in the `X-Rate-Limit-Window` header.

Pseudo code for this is:

```ruby
if res.status == 429
  // Wait for the specified time
  sleep res.headers['Retry-After'].to_i
  // Retry the request
  client.http.get ...
elsif res.headers['X-Rate-Limit-Remaining'].to_i == 0
  sleep res.headers['X-Rate-Limit-Window'].to_i
end
```

In a future release, this type of throttling should be automatically built into the Ruby SDK.

## Summary

The RingCentral Profile Image API is a useful way to upload corporate address book images individually and administratively. It can be used for exciting use cases like directory sync, upload from mobile phones and setting default images.

If you have questions on this API or this gem, please feel free to ask on the following sites:

* [Stack Overflow](http://stackoverflow.com/questions/tagged/ringcentral)
* [GitHub](https://github.com/ringcentral-ruby/ringcentral-avatars-ruby/issues)
