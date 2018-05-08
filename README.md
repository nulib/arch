# Arch
Arch is our institutional repository and is a lightly modified Hyrax head.

## Software Architecture 
Right now we are hosting Arch locally and it has it's own instance of Fedora 4. It's using our shared, local Solr instance however. We have plans in the future to migrate it to AWS. 

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

## Developer Installation

  * Clone this repository `git clone git@github.com:nulib/institutional-repository.git`
  * From inside the project directory run `bundle install`
  * Replace the `config/*.yml.example` configuration files with actual config values and rename to `.yml`
  * Start the docker stack with `bundle exec rake docker:dev:up`
  * From inside the project directory run `bundle exec rake db:setup`

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
  * Deploy with capistrano, specifying the environment, ex: `cap staging deploy`
