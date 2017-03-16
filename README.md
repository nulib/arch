
(based on Sufia 7)

## Developer Dependencies

These should match closely with the [Sufia 7 requirements](https://github.com/projecthydra/sufia/blob/master/README.md):
  * Ruby 2.3.0 and rbenv, Bundler
  * JDK
  * Imagemagick `brew install imagemagick —with-libtiff —with-jp2`
  * ffmpeg `brew install ffmpeg --with-fdk-aac --with-libvpx --with-libvorbis`
  * fits `brew install fits`
  * redis `brew install redis`

## Developer Installation

  * Clone this repository `git clone git@github.com:nulib/institutional-repository.git`
  * From inside the project directory run `bundle install`
  * Replace the `config/*.yml.example` configuration files with actual config values and rename to `.yml`
  * From inside the project directory run `bundle exec rake db:migrate`
  
## Running the application

  * From the project root start redis `redis-server`
  * In a separate tab, start Sidekiq `bundle exec sidekiq`
  * In a separate tab, start Fedora `fcrepo_wrapper`
  * In a separate tab, start Solr `solr_wrapper`
  * Start the Rails app `rails s`
