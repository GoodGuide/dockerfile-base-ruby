FROM quay.io/goodguide/oracle-java:8

RUN apt-get update \
 && apt-get install \
      autoconf \
      bison \
      byacc \
      build-essential \
      git \
      libffi-dev \
      libgdbm-dev \
      libgdbm3 \
      libncurses5-dev \
      libreadline6-dev \
      libssl-dev \
      libyaml-dev \
      subversion \
      zlib1g-dev

ENV RUBY_VERSION=jruby-1.7.22 RUBY_PREFIX=/usr/local

# Disable default RDoc/ri generation when installing gems
RUN set -x \
 && echo 'gem: --no-rdoc --no-ri' >> /usr/local/etc/gemrc \

# Use ruby-build to install Ruby
 && git clone https://github.com/sstephenson/ruby-build.git /tmp/ruby-build \

# Install ruby via ruby-build
 && /tmp/ruby-build/bin/ruby-build -v $RUBY_VERSION $RUBY_PREFIX \

 && rm -rf /tmp/ruby-build \

 # update rubygems
 && gem update --system \

 # Set up JRuby options in the .jrubyrc
 && jruby --properties | sed "/compat.version/ c\compat.version=2.0" > /root/.jrubyrc

# for dependant images, again update rubygems and bundler upon building
# off this image to ensure everything's up-to-date
ONBUILD RUN gem update --system
