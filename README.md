# QasimK

My personal site is at <https://iamqasimk.com>.

## Development

### Setup

1. [Install RVM](https://rvm.io/rvm/install) - Qasim, make sure you follow the full instructions this time.
2. `rvm install $(cat .ruby-version)`
3. `rvm gemset create $(cat .ruby-gemset)`

Note: `cd`ing into this project root will activate the development environment
due to `.ruby-gemset` and `.ruby-version`.

4. `gem install bundler`
5. `bundle` to install dependencies

### Development process

Simply execute `make watch` and browse over to <http://localhost:4000>.

## Deployment

The website will automatically deploy when pushing master to
<https://github.com/QasimK/qasimk.github.io>. This uses GitHub's automatic
Jekyll site building. The domain <https://iamqasimk.com> points to GitHub's
servers.

## Tools

* <http://www.favicomatic.com/>
