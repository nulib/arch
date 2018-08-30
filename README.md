# Arch
Arch is our institutional repository and is a modified Hyrax head.

## Software Architecture
Right now we are hosting Arch on AWS. It's using NUL's shared Fedora 4 instance and has it's own solr core on our shared Solr instance.

## Developer Dependencies

These should match closely with the [Hyrax requirements](https://github.com/projecthydra-labs/hyrax):
  * Ruby 2.3.0 and rbenv, Bundler (https://github.com/rbenv/rbenv#homebrew-on-mac-os-x)
    * If you get permission errors running `gem install bundler`, try the following:
      * Set your global ruby environment by running: `rbenv global 2.3.0`
      * In your user's .bash_profile, include this line at the bottom: eval "$(rbenv init -)"
      * Open a new terminal window and run: `gem install bundler`
  * Download and install LibreOffice https://www.libreoffice.org/download/download/
  * Imagemagick `brew install imagemagick --with-ghostscript --with-openjpeg`
  * ffmpeg `brew install ffmpeg --with-fdk-aac --with-libvpx --with-libvorbis`
  * fits `brew install fits`
  * vips `brew install vips`
  * Install [`devstack`](https://github.com/nulib/devstack) according to the instructions in the README

## Developer Installation

  * Clone this repository `git clone git@github.com:nulib/institutional-repository.git`
  * From inside the project directory run `bundle install`
  * Start the docker stack with `devstack up arch`
  * From inside the project directory run `bundle exec rake db:setup zookeeper:upload zookeeper:create`

## Initially running the application

  * Start the Rails app `rails s`
  * In your browser, log in using your netid
  * Back in terminal, run the rake task `bundle exec rake add_admin_role` to make your user an admin
  * Back in the browser, navigate to the newly visible `Administration` link on the top navbar
  * Click `Administrative Sets` on the left hand navigation menu
  * Create a new admin set, feel free to name it whatever you want, and click save
  * After saving your new set, click the `Workflow`
  * Select the `Default Workflow` and click save

  Now you can use the application normally

 ## Deploying
  * Submit a PR in github to the environment's deploy branch that you're targeting
    For example, to deploy to staging submit a PR to `deploy/staging`
