# QasimK

My personal site is at <https://iamqasimk.com>.

## Development

We use Vagrant to isolate the development environment. If you do not want to use
Vagrant, then the manual steps are documented in `provision.sh`.

    $ vagrant init
    $ vagrant up
    $ xdg-open http://localhost:4000

Note: This is a lie :) Vagrant is coming one day.

### Setup

1. [Install RVM](https://rvm.io/rvm/install) - Qasim, make sure you follow the full instructions this time.
2. `rvm install $(cat .ruby-version)`
3. `rvm gemset create $(cat .ruby-gemset)`

Note: `cd`ing into this project root will activate the development environment
due to `.ruby-gemset` and `.ruby-version`.

4. `rvm $(rvm current) do gem install bundler`
5. `rvm $(rvm current) do bundle` to install dependencies

### Development process

Simply execute `make watch` and browse over to <http://localhost:4000>.

## Deployment

The website will automatically deploy when pushing master to
<https://github.com/QasimK/qasimk.github.io>. The website will be available
at <http://iamqasimk.com>.

GitHub will automatically build the website, and a configured DNS CNAME record
allows them to host the website, but they do not support HTTPS on custom domains
(yet).

## Tools

* <http://www.favicomatic.com/>

## Structure

Maybe something like

iamqasimk.com/essays/a-driverless-vision/
iamqasimk.com/blog/2018/single-app-vpn/
iamqasimk.com/blog/tags/
iamqasimk.com/blog/tags/linux
iamqasimk.com/talks/solid-1-srp/
iamqasimk.com/recommendations/
iamqasimk.com/comments/
iamqasimk.com/comments/fiction/mistborn/
iamqasimk.com/comments/films/spirited-away/
iamqasimk.com/comments/games/bastion/
iamqasimk.com/comments/series/battlestar-galactica/
iamqasimk.com/comments/anime/psycho-pass/
iamqasimk.com/comments/tabletop/munchkin/

Blog could possibly be sub-divided into technical articles and not?
Blog has tags.
Scribbles will be moved to twitter.
