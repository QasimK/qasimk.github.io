
# Heroku in One Hour

Let's create a simple, maintainable Python web application using Heroku as fast as possible.

## Environment

* Ensure Vagrant is installed on your machine. This will create an isolated development environment.
* Create git repo: `git init` with README, LICENSE, .gitignore files.
* `vagrant init ubuntu/bionic64`
* `vagrant up --provider virtualbox`
* `vagrant ssh`

Now we will run commands inside of vagrant

* `sudo apt update && sudo apt upgrade`
* `sudo apt install python3-pip`
* `pip3 install --user pipenv`
* `cd /vagrant`
* `pipenv --three` (NB: May need to add `~/.local/bin` to $PATH.)
* `pipenv install --dev pre-commit`
* Setup black (config file): https://github.com/ambv/black#version-control-integration
* `pre-commit install`.

NOTE: Encapsulate this within the vagrant provision

## Heroku

Create Heroku App.
