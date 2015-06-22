FROM goodguide/base

MAINTAINER GoodGuide "docker@goodguide.com"

RUN aptitude install --assume-yes \
      autoconf \
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

ADD 1.9.3-p327-falcon /opt/ruby-build/share/ruby-build/1.9.3-p327-falcon

ENV PATH /opt/ruby-build/bin:$PATH
ENV RUBY_PREFIX /usr/local
ENV RUBY_VERSION 1.9.3-p327-falcon

# Performance tuning for Ruby:
ENV RUBY_GC_MALLOC_LIMIT=60000000
ENV RUBY_FREE_MIN=200000
# ENV CFLAGS="-march=native -O3 -pipe -fomit-frame-pointer -fno-tree-dce -fno-optimize-sibling-calls"

# Install ruby via ruby-build
RUN ruby-build -v $RUBY_VERSION $RUBY_PREFIX

# update rubygems and install bundler
RUN gem update --system
RUN gem install bundler

# for dependant images, again update rubygems and bundler upon building
# off this image to ensure everything's up-to-date
ONBUILD RUN gem update --system
ONBUILD RUN gem install bundler
