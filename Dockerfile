FROM goodguide/base

MAINTAINER GoodGuide "docker@goodguide.com"

RUN aptitude install --assume-yes \
      autoconf \
      byacc \
      libreadline-dev \
      libssl-dev \
      libxml2-dev \
      libxslt-dev \
      subversion \
      zlib1g-dev \
 && aptitude clean

# Disable default RDoc/ri generation when installing gems
RUN echo "gem: --no-rdoc --no-ri" >> /usr/local/etc/gemrc

# Use ruby-build to install Ruby
RUN git clone https://github.com/sstephenson/ruby-build.git /opt/ruby-build

ENV PATH /opt/ruby-build/bin:$PATH
ENV RUBY_PREFIX /usr/local
ENV RUBY_VERSION 1.8.7-p375

# Install ruby via ruby-build
RUN ruby-build -v $RUBY_VERSION $RUBY_PREFIX

# update rubygems and install bundler
RUN gem update --system
RUN gem install bundler

# for dependant images, again update rubygems and bundler upon building
# off this image to ensure everything's up-to-date
ONBUILD RUN gem update --system
ONBUILD RUN gem install bundler
