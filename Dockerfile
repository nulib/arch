#################################
# Build the support container
FROM ruby:2.6.5-slim-stretch as base
LABEL edu.northwestern.library.app=Arch \
      edu.northwestern.library.stage=build \
      edu.northwestern.library.role=support

ENV BUILD_DEPS="build-essential libpq-dev libsqlite3-dev tzdata locales git curl unzip" \
    DEBIAN_FRONTEND="noninteractive" \
    RAILS_ENV="production" \
    LANG="en_US.UTF-8" \
    FITS_VERSION="1.0.5"

RUN useradd -m -U app && \
    su -s /bin/bash -c "mkdir -p /home/app/current" app

RUN apt-get update -qq && \
    apt-get install -y $BUILD_DEPS --no-install-recommends

RUN \
    # Set locale
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    \
    mkdir -p /tmp/stage/bin && \
    \
    # Install FFMPEG
    mkdir -p /tmp/ffmpeg && \
    cd /tmp/ffmpeg && \
    curl https://s3.amazonaws.com/nul-repo-deploy/ffmpeg-release-64bit-static.tar.xz | tar xJ && \
    cp `find . -type f -executable` /tmp/stage/bin/ && \
    \
    # Install FITS
    cd /tmp && \
    curl -O https://s3.amazonaws.com/nul-repo-deploy/fits-${FITS_VERSION}.zip && \
    cd /tmp/stage && \
    unzip -o /tmp/fits-${FITS_VERSION}.zip && \
    \
    # Update bundler
    gem update --system && \
    gem update bundler

USER app
WORKDIR /home/app/current

COPY --chown=app:app Gemfile /home/app/current/
COPY --chown=app:app Gemfile.lock /home/app/current/

RUN chown -R app:app /home/app/current &&  \
    bundle install --jobs 20 --retry 5 --with aws:postgres --without development:test --path vendor/gems && \
    rm -rf vendor/gems/ruby/*/cache/* vendor/gems/ruby/*/bundler/gems/*/.git

#################################
# Build the Application container
FROM ruby:2.6.5-slim-stretch as app
LABEL edu.northwestern.library.app=Arch \
      edu.northwestern.library.stage=run \
      edu.northwestern.library.role=app


RUN useradd -m -U app && \
    su -s /bin/bash -c "mkdir -p /home/app/current/vendor/gems" app

ENV RUNTIME_DEPS="imagemagick libexif12 libexpat1 libgif7 glib-2.0 libgsf-1-114 libjpeg62-turbo libpng16-16 libpoppler-glib8 libpq5 libreoffice librsvg2-2 libsqlite3-0 libtiff5 locales nodejs openjdk-8-jre postgresql-client tzdata yarn" \
    DEBIAN_FRONTEND="noninteractive" \
    RAILS_ENV="production" \
    LANG="en_US.UTF-8" \
    FITS_VERSION="1.0.5"

RUN mkdir -p /usr/share/man/man1 /usr/share/man/man7 && \
    apt-get update -qq && \
    apt-get install -y curl gnupg2 --no-install-recommends && \
    # Install NodeJS and Yarn package repos
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    # Install runtime dependencies
    apt-get update -qq && \
    apt-get install -y $RUNTIME_DEPS --no-install-recommends && \
    # Install webpack
    alias nodejs=node && \
    yarn add webpack && \
    # Set locale
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8 && \
    # Install VIPS
    cd /tmp && \
    curl -sO https://s3.amazonaws.com/nul-repo-deploy/packages/libvips-tools_8.7.4-1_amd64.deb && \
    curl -sO https://s3.amazonaws.com/nul-repo-deploy/packages/libvips-dev_8.7.4-1_amd64.deb && \
    curl -sO https://s3.amazonaws.com/nul-repo-deploy/packages/libvips42_8.7.4-1_amd64.deb && \
    curl -sO https://s3.amazonaws.com/nul-repo-deploy/packages/gir1.2-vips-8.0_8.7.4-1_amd64.deb && \
    apt-get install -y $(find . -name '*.deb') && \
    # Clean up package cruft
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/*.deb && \
    # Update Bundler
    gem update --system && \
    gem update bundler

COPY --from=base /tmp/stage/bin/* /usr/local/bin/
COPY --from=base /tmp/stage/fits-${FITS_VERSION} /usr/local/fits
COPY --chown=app:staff --from=base /usr/local/bundle /usr/local/bundle
COPY --chown=app:app --from=base /home/app/current/vendor/gems/ /home/app/current/vendor/gems/
COPY --chown=app:app . /home/app/current/

RUN mkdir /var/run/puma && chown root:app /var/run/puma && chmod 0775 /var/run/puma

USER app
WORKDIR /home/app/current
RUN bundle exec rake assets:precompile SECRET_KEY_BASE=$(ruby -r 'securerandom' -e 'puts SecureRandom.hex(64)')

EXPOSE 3000
CMD bin/boot_container
HEALTHCHECK --start-period=60s CMD curl -f http://localhost:3000/
