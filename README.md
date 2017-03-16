
(based on Sufia 7)

##Developer Dependencies

These should match closely with the [Sufia 7 requirements](https://github.com/projecthydra/sufia/blob/master/README.md):
  * Ruby 2.3.0 and rbenv, Bundler
  * JDK
  * Imagemagick `brew install imagemagick —with-libtiff —with-jp2`
  * ffmpeg `brew install ffmpeg --with-fdk-aac --with-libvpx --with-libvorbis`
  * fits `brew install fits`
  * redis `brew install redis`

##Developer Installation

  * Clone this repository `git clone `
  * From inside the project directory run `bundle install`
  * Replace the `config/*.yml.example` configuration files with actual config values and rename to `.yml`
