== README

NUfia app based on Sufia 7.

##Dependencies
###Dependencies on web (rails) box
These should match closely with the [Sufia 7 requirements](https://github.com/projecthydra/sufia/blob/master/README.md):
  * Tested using Ruby 2.3.0 and rbenv
  * Ruby gems listed in the Gemfile. Can use bundle install to install them.
  * Phusion Passenger 5.0.27
  * Apache2 w/modssl
  * Imagemagick 6.7.8-9
  * ffmpeg 2.4.2-1
  * fits
    
###Dependencies on app server:
  * Redis
  * Fedora 4.5.1 using MySQL
  * MySQL 5
  * Solr 4.10.4
  * Tomcat 7.0.68
  * Java 8 (1.8.0_74)

##Firewall
  * ports 80 and 443 open for web (rails) server
  * ports 3000 (redis), 3306 (mysql), 8080 (Fedora), and 8983 (solr) on app server

##Apache Webserver
Apache is configured to listen on ports 80 and 443.  SSL certificates are currently not installed by puppet, but must be moved into place manually.  This may be changed in a later release.

##Database creation
Puppet should create the database and permissions. Here are the commands to do it manually if needed;
```
create database nufia_production character set utf8 collate utf8_bin;
grant all on nufia_production* to nufia_production@localhost identified by 'password';
grant all on nufia_production* to nufia_production@hostname.of.db.server identified by 'password';
flush privileges;
```

##Database initialization
Capistrano runs rake db:migrate to deploy the appropriate database.

##How to run the test suite

##Using capistrano to deploy.
Deploying with capistrano is relatively simple. These instructions assume you have either
checked out the code from github, or are running it in a vagrant virtual machine. The
Capfile, config/deploy.rb, config/deploy/[staging|production].rb files have already been
set up.
  1. cd to the location of nufia (probably /var/www/nufia).
  2. type `cap staging deploy --dry-run` (or `cap production deploy --dry-run`). The
dry run just tests things out. Run as the "vagrant" user or the one configured in the 
config/deploy/[staging|production].rb file.
  3. type `cap staging deploy` (or `cap production deploy`) to perform the installation for 
real. Note that capistrano does a number of different things, it asks to pull the code
from github for a particular branch, deploys the code, runs bundle install, rake db:migrate,
restarts sidekiq, restarts passenger, and more. This command should take care of the full
deployment.
  4. If this is a new deployment, there may be a couple of items you may need to do:
     * For NU installations, You may need to checkout code from github.com/nulib/miscellany into /usr/local/nufia/nufia_config. The private config yml files are expected there.
     * During deployment, if you see an error about missing yml files and you have them set up per the instructions above, you may need to run `cap staging create_symlink` or `cap production create_symlink`. Then re-run the deployment.
     * This may have been configured in Puppet, but /etc/monit/conf.d directory needs to be created and owned by the deploy user.

##Starting sidekiq
This is the command to start sidekiq in case it needs to be started again:
```
su - vagrant
cd /var/www/nufia
bundle exec sidekiq -C config/sidekiq.yml -L log/sidekiq.log --environment production -d
```
Of course, replace "production" with "staging" if you're running this command in the
staging environment.


## SOLR configuration

The configuration for SOLR uses the tomcat and nul_solr puppet classes.  The Puppet code is fairly self-documenting.  An http connector is configured that listens on port 8983.

The following classes are used:

    nul_solr
    tomcat 
    tomcat::instance
    tomcat::config::server
    tomcat::config::server::connector (for tomcat-solr-ajp)
    tomcat::config::server::connector (for tomcat-solr-http, port 8983)
    tomcat::war
    nul_solr::post-install
    nul_solr::context
    tomcat::service
    tomcat::setenv::entry (x3)

