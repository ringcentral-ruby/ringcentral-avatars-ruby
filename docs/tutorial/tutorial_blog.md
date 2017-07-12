# Updating the RingCentral Address Book with Default Avatars

The RingCentral corporate directory is a unified way to reach out to your corporate contacts. Profile images are stored in the cloud and pushed out to RingCentral endpoints including RingCentral iOS/Android mobile apps and the Mac/Windows desktop apps. If your company has multiple RingCentral accounts, your contacts across accounts can be unified in using RingCentral’s Account Federation feature.

To improve the user experience, companies are often interested in updating the profile images with the following use cases:

* load their own profile images, such as from Active Directory, and/or
* load default images such as user initials or identicons.

Both of these use cases can be enabled by the RingCentral Profile Image API at an individual and administrative level.

This article provides and overview of the Profile Image API and then walks through how to create default avatars for users that don’t have an image.

## The Profile-Image API Endpoint

The profile image API endpoint is available in the API Reference and API Explorer:

* API Reference: https://developer.ringcentral.com/api-docs
* API Explorer: https://developer.ringcentral.com/api-explorer

Every user’s REST API endpoint is as follows:

* GET /restapi/v1.0/account/{acctId}/extension/{extId}

The Profile Image endpoint is as follows and supports read, create and update respectively:

* GET /restapi/v1.0/account/{acctId}/extension/{extId}/profile-image
* POST /restapi/v1.0/account/{acctId}/extension/{extId}/profile-image
* PUT /restapi/v1.0/account/{acctId}/extension/{extId}/profile-image

When calling the POST or PUT method to create or update a profile image, a multi-part/form request using the ‘image’ property.

## Creating Default Avatars

To create default avatars you need to perform few steps:

1. Retrieve a list of users to update, e.g. check that they do not have an existing image.
1. For each extension that requires an image do the following, generate the image. This can use user initials which requires generating the initials and then an image, or using identicons which requires passing in any string as a seed, e.g. a name or email address. For identicons, a service such as Gravatar can also be used to produce an image using the MD5 hash of the user’s email address
1. Upload the image for each user.
1. When there are many users, you may need to throttle your application to ensure you are below the API rate limits. Some SDKs have built-in rate-limiting that can do this for you.

### Detailed Steps using Ruby

The process of creating and loading initial based avatars or identicons is available online in the `ringcentral-avatars-ruby` Github repository and described in the `TUTORIAL.md` file. Below is a quick description of the steps in the previous section.

#### Retrieve a list of users without images

Use the `account/~/extension` endpoint to retrieve a list of extensions and filter on the `profileImage.etag` property to create a list without existing images.

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

#### Create an avatar

An default avatar can be created using initials with the avatarly Ruby gem and using identicons using the ruby_identicon Ruby gem as shown below:

```ruby
# Using Initials
require 'avatarly'
blob = Avatarly.generate_avatar 'AZ'

# Using Identicons
require 'ruby_identicon'
blob = RubyIdenticon.create 'AZ'
```

#### Post the avatar

From here, convert this to a Faraday::UploadIO object to pass to the SDK’s Faraday client:

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

If you are using languages other than Ruby, you can use the steps above to create your own solution. If you are using Ruby, this has been done for you and you can use the ringcentral-avatars-ruby Ruby gem directly as follows with more options available in the README.md file:

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

## Summary

RingCentral’s Profile Image API provides an easy way to customize your corporate directory images whether you wish to load profile images from ActiveDirectory or create default images for your users. If you wish to learn more about this API, please reach out to us on our [Developer Community](https://devcommunity.ringcentral.com) or [Stack Overflow](https://stackoverflow.com/questions/tagged/ringcentral).
