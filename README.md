# QasimK

My personal site is at <https://qasimk.io>.

## Development

We use Vagrant to isolate the development environment. If you do not want to use
Vagrant, then the manual steps are documented in `provision.sh`.

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
at <https://qasimk.io>.

GitHub will automatically build the website, and a configured DNS CNAME record
allows them to host the website, but they do not support HTTPS on custom domains
(yet).

## Tools

* <http://www.favicomatic.com/>

## Structure

Maybe something like

qasimk.io/site-map/
qasimk.io/ideas/a-cycle-friendly-city/
qasimk.io/essays/a-driverless-vision/
qasimk.io/blog/2018/single-app-vpn/
qasimk.io/blog/tags/
qasimk.io/blog/tags/linux
qasimk.io/talks/solid-1-srp/
qasimk.io/recommendations/
qasimk.io/comments/
qasimk.io/comments/speculative/the-art-of-thinking-clearly/
qasimk.io/comments/fiction/mistborn/
qasimk.io/comments/films/spirited-away/
qasimk.io/comments/games/bastion/
qasimk.io/comments/series/battlestar-galactica/
qasimk.io/comments/anime/psycho-pass/
qasimk.io/comments/tabletop/munchkin/

Blog categories: Tech Notes (+Talks), Essays, Ideas
Different styles.

Blog could possibly be sub-divided into technical articles and not?
Blog has tags.
Scribbles will be moved to twitter.
