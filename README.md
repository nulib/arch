# Arch

Arch is our institutional repository and is a Hyrax 2 application.

## Environments

- Production: https://arch.library.northwestern.edu/
- Staging: http://arch.stack.rdc-staging.library.northwestern.edu/
- Local development: http://devbox.library.northwestern.edu/

## Software Architecture

Arch is hosted on AWS. It's using NUL's shared Fedora 4 instance and has it's own Solr core on a shared Solr instance.

## Developer Dependencies

These should match closely with the [Hyrax requirements](https://github.com/projecthydra-labs/hyrax):

- Ruby 2.3.0 and rbenv, Bundler (https://github.com/rbenv/rbenv#homebrew-on-mac-os-x)
  - If you get permission errors running `gem install bundler`, try the following:
    - Set your global ruby environment by running: `rbenv global 2.3.0`
    - In your user's .bash_profile, include this line at the bottom: eval "\$(rbenv init -)"
    - Open a new terminal window and run: `gem install bundler`
- Download and install LibreOffice https://www.libreoffice.org/download/download/
- Imagemagick `brew install imagemagick --with-ghostscript --with-openjpeg`
- ffmpeg `brew install ffmpeg --with-fdk-aac --with-libvpx --with-libvorbis`
- fits `brew install fits`
- vips `brew install vips`
- Install [`devstack`](https://github.com/nulib/devstack) according to the instructions in the README
- Follow the [Authentication Setup for Dev Environment](https://github.com/nulib/donut/wiki/Authentication-setup-for-dev-environment) instructions

## Developer Installation

- Clone this repository `git clone git@github.com:nulib/institutional-repository.git`
- Grab the development environment configs from the `miscellany` repo: `arch/config/settings/development.local.yml` and save to `config/settings/development.local.yml` inside the project.
- From inside the project directory run `bundle install`
- Start the docker stack with `devstack up arch`
- From inside the project directory run `bundle exec rake arch:seed`
  - You can include the optional arguments to create an admin user (such as yourself). Ex: `bundle exec rake arch:seed ADMIN_USER=your_netid ADMIN_EMAIL=your_email@northwestern.edu`
- In a separate tab, start the rails server `bundle exec rails server`
- You can see the app in a browser at http://devbox.library.northwestern.edu

## Running the tests

- Start the test stack `devstack -t up arch`
- Run the seed task for the test environmenbt: `bundle exec rake arch:seed RAILS_ENV=test`
- Run the test suite: `bundle exec rspec`

## Deploying

- Submit a PR in github to the environment's deploy branch
  - To deploy to staging submit a PR to `deploy/staging`
  - To deploy to production submit a PR to `master`
