RingCentral Avatars
===================

[![Gem Version][gem-version-svg]][gem-version-url]
[![Build Status][build-status-svg]][build-status-url]
[![Dependency Status][dependency-status-svg]][dependency-status-url]
[![Codacy Badge][codacy-svg]][codacy-url]
[![Code Climate][codeclimate-status-svg]][codeclimate-status-url]
[![Scrutinizer Code Quality][scrutinizer-status-svg]][scrutinizer-status-url]
[![Downloads][downloads-svg]][downloads-url]
[![Docs][docs-rubydoc-svg]][docs-rubydoc-url]
[![License][license-svg]][license-url]
[![Chat][chat-svg]][chat-url]

## Overview

This library will build [RingCentral](https://ringcentral.com) avatars using Gmail-like default avatars. It can build Gmail-like avatars for the following:

* all RingCentral users (extensions) without images
* all RingCentral users, overwriting existing images (useful for testing in Sandbox accounts)
* specific extensions
* authorized user extension only

Additional resources include:

* [Tutorial Video - https://youtu.be/8jCwxfWl_a4](https://www.youtube.com/watch?v=8jCwxfWl_a4)
* [Tutorial Slides - grokify.github.io/ringcentral-avatars-ruby/tutorial/presentation/](https://grokify.github.io/ringcentral-avatars-ruby/tutorial/presentation/)

By default, the images will look like the following in the RingCentral softphone:

![](https://raw.githubusercontent.com/ringcentral-ruby/ringcentral-avatars-ruby/master/docs/images/ringcentral-avatars-softphone.png)

This library uses [Avatarly](https://github.com/lucek/avatarly) to generate the avatars and can pass through any avatar option for customization purposes.

Experimental [Identicon](https://en.wikipedia.org/wiki/Identicon) support is also included via [ruby_identicon](https://github.com/chrisbranson/ruby_identicon). Please see the source for usage until it gets a bit more use.

PNG metadata is supported which can be uploaded to and downloaded from RingCentral.

## Pre-requisites

* ImageMagick
* A RingCentral account (production or sandbox) with [REST API access](https://developers.ringcentral.com)
* A RingCentral administrator account is necessary to update profile images for others

Test first in sandbox. Your app needs to be graduated in order to run against your production account.

## Installation

```bash
$ gem install ringcentral-avatars
```

## Usage

```ruby
require 'ringcentral-avatars'
require 'ringcentral_sdk'

client = RingCentralSdk::REST::Client.new [...]

avatars = RingCentral::Avatars.new client                                # Default options
avatars = RingCentral::Avatars.new client, avatar_opts: {font_size: 275} # Avatarly options

avatars.create_defaults             # create default avatars only
avatars.create_all                  # create all avatars, overwriting existing avatars

avatars.create_mine                 # does not overwrite existing user avatar
avatars.create_mine overwrite: true # overwrite existing user avatar

avatars.create_avatar ext                  # create a default for an extension hash
avatars.create_avatar ext, overwrite: true # overwrite existing for an extension hash
```

* For batch operations, consider using [RingCentral SDK's] `config.retry = true` option for automatic handling of rate limiting using 429 headers.
* For avatar customization, see [Avatarly](https://github.com/lucek/avatarly) options. The default avatar size is `600`.

### Adding PNG Metadata

RingCentral Avatars supports adding PNG Metadata per the [W3C PNG Specification](https://www.w3.org/TR/PNG/#11textinfo). This can be useful for tracking avatars created by this library for selective updates vs. avatars uploaded via other means.

The default description is `RingCentral Default Avatar`, however it can be modified as shown below.

```ruby
avatars = RingCentral::Avatars.new client, png_metadata: { 'Description': 'RingCentral Avatar' }

avatars.png_metadata['Description'] = 'Updated Description'
```

## Sample Scripts

The following sample scripts are provided in the GitHub repo under the `./scripts` directory.

* `update_avatar.rb` - Updates all or own avatar image with optional rewrite CLI arguments.
* `get_avatar.rb` - Retrieve and save own avatar image to `_my_avatar.png` file.
* `avatar_info.rb` - Parses and dumps PNG metadata for validation of `_my_avatar.png` file.

To run these files, install dependencies and configure the demo with the following: 

```bash
$ cd scripts
$ bundle
$ cp rc_config_sample.env.txt .env
$ vi .env
```

Run the scripts with the following:

```bash
$ ruby update_avatar.rb --overwrite
$ ruby get_avatar.rb
$ ruby avatar_info.rb
```

## Test Uploads

The `scripts` directory contains test images for `png`, `jpg`, and `gif` file types: `test_filetype_png.png`, `test_filetype_jpg.jpg`, and `test_filetype_gif.gif`.

### Test Upload Script

This repo also includes test scripts to upload PNG, JPG, and GIF format images.

```bash
$ cd ringcentral-avatars-ruby/scripts
$ vi .env
$ ruby test_filetype.rb --filetype=png
$ ruby test_filetype.rb --filetype=jpg
$ ruby test_filetype.rb --filetype=gif
```

### Test cURL Command

```bash
$ curl -v -H 'Authorization: Bearer <MY_ACCESS_TOKEN>' -F image=@test_filetype_gif.gif 'https://platform.devtest.ringcentral.com/restapi/v1.0/account/~/extension/~/profile-image'
```

### Change Log

See [CHANGELOG.md](CHANGELOG.md)

## Credits

Test icons files are adapted from freeware [Filetype Icons](http://www.iconarchive.com/show/filetype-icons-by-graphicloads.html) by [GraphicLoads](http://www.iconarchive.com/artist/graphicloads.html).

## Links

Project Repo

* https://github.com/ringcentral-ruby/ringcentral-avatars-ruby

RingCentral Ruby SDK

* https://github.com/ringcentral-ruby/ringcentral-sdk-ruby

RingCentral API Explorer

* https://developer.ringcentral.com/api-explorer/latest/index.html

PNG Info

* https://www.w3.org/TR/PNG/#11textinfo

## Contributing

1. Fork it ( http://github.com/ringcentral-ruby/ringcentral-avatars-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

RingCentral Avatars is available under an MIT-style license. See [LICENSE.txt](LICENSE.txt) for details.

RingCentral Avatars &copy; 2016 by John Wang

 [gem-version-svg]: https://badge.fury.io/rb/ringcentral-avatars.svg
 [gem-version-url]: http://badge.fury.io/rb/ringcentral-avatars
 [downloads-svg]: http://ruby-gem-downloads-badge.herokuapp.com/ringcentral-avatars
 [downloads-url]: https://rubygems.org/gems/ringcentral-avatars
 [build-status-svg]: https://api.travis-ci.org/ringcentral-ruby/ringcentral-avatars-ruby.svg?branch=master
 [build-status-url]: https://travis-ci.org/ringcentral-ruby/ringcentral-avatars-ruby
 [codacy-svg]: https://api.codacy.com/project/badge/Grade/e82eac58a42d4463885627f78098bbb0
 [codacy-url]: https://www.codacy.com/app/ringcentral-ruby/ringcentral-avatars-ruby
 [coverage-status-svg]: https://coveralls.io/repos/ringcentral-ruby/ringcentral-avatars-ruby/badge.svg?branch=master
 [coverage-status-url]: https://coveralls.io/r/ringcentral-ruby/ringcentral-avatars-ruby?branch=master
 [dependency-status-svg]: https://gemnasium.com/ringcentral-ruby/ringcentral-avatars-ruby.svg
 [dependency-status-url]: https://gemnasium.com/ringcentral-ruby/ringcentral-avatars-ruby
 [codeclimate-status-svg]: https://codeclimate.com/github/ringcentral-ruby/ringcentral-avatars-ruby/badges/gpa.svg
 [codeclimate-status-url]: https://codeclimate.com/github/ringcentral-ruby/ringcentral-avatars-ruby
 [scrutinizer-status-svg]: https://scrutinizer-ci.com/g/ringcentral-ruby/ringcentral-avatars-ruby/badges/quality-score.png?b=master
 [scrutinizer-status-url]: https://scrutinizer-ci.com/g/ringcentral-ruby/ringcentral-avatars-ruby/?branch=master
 [docs-rubydoc-svg]: https://img.shields.io/badge/docs-rubydoc-blue.svg
 [docs-rubydoc-url]: http://www.rubydoc.info/gems/ringcentral-avatars/
 [license-svg]: https://img.shields.io/badge/license-MIT-blue.svg
 [license-url]: https://github.com/ringcentral-ruby/ringcentral-avatars-ruby/blob/master/LICENSE.md
 [chat-svg]: https://img.shields.io/badge/chat-on%20glip-orange.svg
 [chat-url]: https://glipped.herokuapp.com/

