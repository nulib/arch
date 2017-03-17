
(based on Sufia 7)

## Developer Dependencies

These should match closely with the [Sufia 7 requirements](https://github.com/projecthydra/sufia/blob/master/README.md):
  * Ruby 2.3.0 and rbenv, Bundler (https://github.com/rbenv/rbenv#homebrew-on-mac-os-x)
    * If you get permission errors running `gem install bundler`, try the following:
      * Set your global ruby environment by running: `rbenv global 2.3.0`
      * In your user's .bash_profile, include this line at the bottom: eval "$(rbenv init -)"
      * Open a new terminal window and run: `gem install bundler`
  * JDK (http://www.oracle.com/technetwork/java/javase/downloads/)
    * Optional - use jenv to manage your Java environment (http://www.jenv.be)
    * jenv does not install JDK versions, so install your JDKs separately.
    * View all your installed JDKs; run: `/usr/libexec/java_home -V`
    * Add a JDK to jenv.  For jdk1.8.0_121.jdk as an example, run: `add /Library/Java/JavaVirtualMachines/jdk1.8.0_121.jdk/Contents/Home`
    * Set up a global version. From above example version, run: `jenv global oracle64-1.8.0.121`
  * Download and install LibreOffice https://www.libreoffice.org/download/download/
  * Imagemagick `brew install imagemagick --with-ghostscript --with-openjpeg`
  * ffmpeg `brew install ffmpeg --with-fdk-aac --with-libvpx --with-libvorbis`
  * fits `brew install fits`
  * redis `brew install redis`

## Developer Installation

  * Clone this repository `git clone git@github.com:nulib/institutional-repository.git`
  * From inside the project directory run `bundle install`
    * If on OSx and if you see a mysql error during bundle install, run: `x-code-select --install`
  * Replace the `config/*.yml.example` configuration files with actual config values and rename to `.yml`
  * From inside the project directory run `bundle exec rake db:migrate`
  
## Running the application

  * From the project root start redis `redis-server`
  * In a separate tab, start Sidekiq `bundle exec sidekiq`
  * In a separate tab, start Fedora `fcrepo_wrapper`
  * In a separate tab, start Solr `solr_wrapper`
  * Start the Rails app `rails s`
  
 ## Deploying
  * Deploy with capistrano, specifying the environment, ex: `cap staging deploy`
