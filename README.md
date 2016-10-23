RingCentral Avatars
===================

[![Gem Version][gem-version-svg]][gem-version-link]
[![Build Status][build-status-svg]][build-status-link]
[![Dependency Status][dependency-status-svg]][dependency-status-link]
[![Code Climate][codeclimate-status-svg]][codeclimate-status-link]
[![Scrutinizer Code Quality][scrutinizer-status-svg]][scrutinizer-status-link]
[![Downloads][downloads-svg]][downloads-link]
[![Docs][docs-rubydoc-svg]][docs-rubydoc-link]
[![License][license-svg]][license-link]

## Overview

This library will build RingCentral avatars using Gmail-like initial avatars. It requires ImageMagick.

The images will look like the following in the RingCentral softphone:

![](ringcentral-avatars.png)

## Usage

```ruby
require 'ringcentral-avatars'
require 'ringcentral_sdk'

client = RingCentralSdk.new [...]

avatars = RingCentralAvatars.new client

avatars.create_all       # create defaults only
avatars.create_all  true # overwrite existing avatars

avatars.create_mine      # create for authorized user only
```

### Change Log

See [CHANGELOG.md](CHANGELOG.md)

## Links

Project Repo

* https://github.com/ringcentral-ruby/ringcentral-avatars-ruby

RingCentral Ruby SDK

* https://github.com/ringcentral-ruby/ringcentral-sdk-ruby

RingCentral API Explorer

* http://ringcentral.github.io/api-explorer

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
 [gem-version-link]: http://badge.fury.io/rb/ringcentral-avatars
 [downloads-svg]: http://ruby-gem-downloads-badge.herokuapp.com/ringcentral-avatars
 [downloads-link]: https://rubygems.org/gems/ringcentral-avatars
 [build-status-svg]: https://api.travis-ci.org/ringcentral-ruby/ringcentral-avatars-ruby.svg?branch=master
 [build-status-link]: https://travis-ci.org/ringcentral-ruby/ringcentral-avatars-ruby
 [coverage-status-svg]: https://coveralls.io/repos/ringcentral-ruby/ringcentral-avatars-ruby/badge.svg?branch=master
 [coverage-status-link]: https://coveralls.io/r/ringcentral-ruby/ringcentral-avatars-ruby?branch=master
 [dependency-status-svg]: https://gemnasium.com/ringcentral-ruby/ringcentral-avatars-ruby.svg
 [dependency-status-link]: https://gemnasium.com/ringcentral-ruby/ringcentral-avatars-ruby
 [codeclimate-status-svg]: https://codeclimate.com/github/ringcentral-ruby/ringcentral-avatars-ruby/badges/gpa.svg
 [codeclimate-status-link]: https://codeclimate.com/github/ringcentral-ruby/ringcentral-avatars-ruby
 [scrutinizer-status-svg]: https://scrutinizer-ci.com/g/ringcentral-ruby/ringcentral-avatars-ruby/badges/quality-score.png?b=master
 [scrutinizer-status-link]: https://scrutinizer-ci.com/g/ringcentral-ruby/ringcentral-avatars-ruby/?branch=master
 [docs-rubydoc-svg]: https://img.shields.io/badge/docs-rubydoc-blue.svg
 [docs-rubydoc-link]: http://www.rubydoc.info/gems/ringcentral-avatars/
 [license-svg]: https://img.shields.io/badge/license-MIT-blue.svg
 [license-link]: https://github.com/ringcentral-ruby/ringcentral-avatars-ruby/blob/master/LICENSE.md
