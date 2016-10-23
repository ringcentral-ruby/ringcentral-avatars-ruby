RingCentral Avatars
===================

[![Gem Version][gem-version-svg]][gem-version-link]
[![Build Status][build-status-svg]][build-status-link]
[![Dependency Status][dependency-status-svg]][dependency-status-link]
[![Code Climate][codeclimate-status-svg]][codeclimate-status-link]
[![Scrutinizer Code Quality][scrutinizer-status-svg]][scrutinizer-status-link]
[![Downloads][downloads-svg]][downloads-link]
[![Docs][docs-readthedocs-svg]][docs-readthedocs-link]
[![Docs][docs-rubydoc-svg]][docs-rubydoc-link]
[![License][license-svg]][license-link]

## Overview

This library will build RingCentral avatars using Gmail-like initial avatars. It requires ImageMagick.

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

* https://github.com/grokify/ringcentral-avatars-ruby

RingCentral Ruby SDK

* https://github.com/grokify/ringcentral-avatars-ruby

RingCentral API Explorer

* http://ringcentral.github.io/api-explorer

## Contributing

1. Fork it ( http://github.com/grokify/ringcentral-avatars-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

RingCentral SDK is available under an MIT-style license. See [LICENSE.txt](LICENSE.txt) for details.

RingCentral SDK &copy; 2015-2016 by John Wang

 [gem-version-svg]: https://badge.fury.io/rb/ringcentral-avatars.svg
 [gem-version-link]: http://badge.fury.io/rb/ringcentral-avatars
 [downloads-svg]: http://ruby-gem-downloads-badge.herokuapp.com/ringcentral-avatars
 [downloads-link]: https://rubygems.org/gems/ringcentral-avatars
 [build-status-svg]: https://api.travis-ci.org/grokify/ringcentral-avatars-ruby.svg?branch=master
 [build-status-link]: https://travis-ci.org/grokify/ringcentral-avatars-ruby
 [coverage-status-svg]: https://coveralls.io/repos/grokify/ringcentral-avatars-ruby/badge.svg?branch=master
 [coverage-status-link]: https://coveralls.io/r/grokify/ringcentral-avatars-ruby?branch=master
 [dependency-status-svg]: https://gemnasium.com/grokify/ringcentral-avatars-ruby.svg
 [dependency-status-link]: https://gemnasium.com/grokify/ringcentral-avatars-ruby
 [codeclimate-status-svg]: https://codeclimate.com/github/grokify/ringcentral-avatars-ruby/badges/gpa.svg
 [codeclimate-status-link]: https://codeclimate.com/github/grokify/ringcentral-avatars-ruby
 [scrutinizer-status-svg]: https://scrutinizer-ci.com/g/grokify/ringcentral-avatars-ruby/badges/quality-score.png?b=master
 [scrutinizer-status-link]: https://scrutinizer-ci.com/g/grokify/ringcentral-avatars-ruby/?branch=master
 [docs-readthedocs-svg]: https://img.shields.io/badge/docs-readthedocs-blue.svg
 [docs-readthedocs-link]: http://ringcentral-avatars-ruby.readthedocs.org/
 [docs-rubydoc-svg]: https://img.shields.io/badge/docs-rubydoc-blue.svg
 [docs-rubydoc-link]: http://www.rubydoc.info/gems/ringcentral-avatars/
 [license-svg]: https://img.shields.io/badge/license-MIT-blue.svg
 [license-link]: https://github.com/grokify/ringcentral-avatars-ruby/blob/master/LICENSE.md
