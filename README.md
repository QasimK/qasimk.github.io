# QasimK

My personal site is at <https://QasimK.io>.

## Writing

- Prefix urls with `{{ '/link' | relative_url }}`.
- em dash:—.
- en dash:-.
- nobreak space: .
- narrow nobreak space: .

## Development

Once in while we should check that our dependencies match GitHub pages:

- <https://pages.github.com/versions/>
- <https://github.com/github/pages-gem/releases>

To run the build locally:

1. `rvm gemset use qasimk`.
2. `make watch` and browse over to <http://localhost:4000>.

### One-time Setup

1. [Install RVM](https://rvm.io/rvm/install) - Qasim, make sure you follow the full instructions this time.
2. [Install the Fish Shell integration](https://rvm.io/integration/fish)
2. `rvm install (cat .ruby-version)`
3. `rvm gemset create (cat .ruby-gemset)`
4. `gem install bundler`
5. `bundle` to install dependencies

Note: `cd`ing into this project root will activate the development environment
due to `.ruby-gemset` and `.ruby-version`.

### Deployment

The website will automatically deploy when pushing master to
<https://github.com/QasimK/qasimk.github.io>. The website will be available
at <https://qasimk.io>.

GitHub will automatically build the website, and a configured DNS CNAME record
allows them to host the website, but they do not support HTTPS on custom domains
(yet).

### Tools

- <https://realfavicongenerator.net/>
- <http://www.favicomatic.com/>
