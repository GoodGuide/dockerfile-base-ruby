FROM quay.io/goodguide/base:ubuntu-16.04

RUN apt-get update \
 && apt-get install \
      autoconf \
      bison \
      byacc \
      build-essential \
      cron \
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

ARG RUBY_VERSION
ENV RUBY_VERSION="$RUBY_VERSION" RUBY_PREFIX=/usr/local

# Disable default RDoc/ri generation when installing gems
RUN echo 'gem: --no-rdoc --no-ri' >> /usr/local/etc/gemrc \

# Use ruby-build to install Ruby
 && git clone https://github.com/sstephenson/ruby-build.git /tmp/ruby-build \

# Install ruby via ruby-build
 && /tmp/ruby-build/bin/ruby-build -v "$RUBY_VERSION" "$RUBY_PREFIX" \

 && rm -rf /tmp/ruby-build \

 # update rubygems
 && gem update --system \
 && gem install bundler --force

CMD ["irb"]

# for dependant images, again update rubygems then install bundler upon building off this image to ensure everything's up-to-date
ONBUILD RUN gem update --system \ 
 && gem install bundler --force
