How to run
===

* Install RVM 

https://rvm.beginrescueend.com/rvm/install/

`bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)`

`source ~/.bash_profile`

`rvm pkg install zlib` -- you need this for thin

`rvm pkg install openssl` -- some libraries use it, notably Amazon AWS APIs. Anything that might be talking over SSL/TLS

`rvm install 1.9.2` -- could use 1.9.3 but meh

`gem install bundler`

Go into the directory of the project, and run `bundle install`

Now, run `thin start` -- the default development environment uses a SQLite database, so DB setup step isn't necessary for development.


