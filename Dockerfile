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

# Fixes tcmalloc error:
ADD ree-1.8.7.2012.02_tcmalloc_patch /opt/ruby-build/share/ruby-build/ree-1.8.7.2012.02_tcmalloc_patch
ADD tcmalloc.patch /opt/ruby-build/share/ruby-build/tcmalloc.patch
RUN mv /opt/ruby-build/share/ruby-build/ree-1.8.7.2012.02_tcmalloc_patch /opt/ruby-build/share/ruby-build/ree-1.8.7-2012.02

ENV PATH /opt/ruby-build/bin:$PATH
ENV RUBY_PREFIX /usr/local
ENV RUBY_VERSION ree-1.8.7-2012.02

# Fixes seg fault during HTTPS requests:
ENV CFLAGS="-O2 -fno-tree-dce -fno-optimize-sibling-calls"

# Install ruby via ruby-build.
RUN ruby-build -v $RUBY_VERSION $RUBY_PREFIX

# update rubygems and install bundler
RUN gem update --system
RUN gem install bundler

# for dependant images, again update rubygems and bundler upon building
# off this image to ensure everything's up-to-date
ONBUILD RUN gem update --system
ONBUILD RUN gem install bundler
