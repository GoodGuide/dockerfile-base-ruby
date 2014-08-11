FROM goodguide/base-oracle-java:7

MAINTAINER GoodGuide "docker@goodguide.com"

RUN aptitude install --assume-yes \
      libreadline-dev \
      libssl-dev \
      libxml2-dev \
      libxslt-dev \
      zlib1g-dev \
 && aptitude clean

# Disable default RDoc/ri generation when installing gems
RUN echo "gem: --no-rdoc --no-ri" >> /usr/local/etc/gemrc

# Use ruby-build to install Ruby
RUN git clone https://github.com/sstephenson/ruby-build.git /opt/ruby-build

ENV PATH /opt/ruby-build/bin:$PATH
ENV RUBY_PREFIX /usr/local
ENV RUBY_VERSION jruby-1.7.12

# Install ruby via ruby-build
RUN ruby-build -v $RUBY_VERSION $RUBY_PREFIX

# update rubygems and install bundler
RUN gem update --system
RUN gem install bundler

# Set up JRuby options in the .jrubyrc
RUN jruby --properties | sed "/compat.version/ c\compat.version=2.0" > /root/.jrubyrc

# for dependant images, again update rubygems and bundler upon building
# off this image to ensure everything's up-to-date
ONBUILD RUN gem update --system
ONBUILD RUN gem install bundler
