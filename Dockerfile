FROM quay.io/goodguide/oracle-java:alpine-3.2-java-8.72.15-0

ENV RUBY_VERSION='jruby-1.7.24' \
    RUBY_PREFIX='/usr/local' \
    RUBY_BUILD_RELEASE='master'

RUN set -x \
 && apk --update add \
     bash \
     ca-certificates \
     curl \
     g++ \
     make \
     tar \

     # n.b. libstdc++ is a runtime dep; don't del later
     libstdc++ \

 # download ruby-build
 && mkdir -p /opt/ruby-build \
 && cd /opt/ruby-build \
 && curl -fsSL "https://github.com/sstephenson/ruby-build/archive/${RUBY_BUILD_RELEASE}.tar.gz" | tar -xzf - --strip-components=1 \

 # Install ruby via ruby-build
 && /opt/ruby-build/bin/ruby-build --verbose "$RUBY_VERSION" "$RUBY_PREFIX" \

 && apk del \
      bash \
      ca-certificates \
      curl \
      g++ \
      make \
      tar \

 # Set up JRuby options in the .jrubyrc
 && jruby --properties | sed "/compat.version/ c\compat.version=2.0" > /root/.jrubyrc \

 && cd / \
 && rm -rf \
      /tmp/* \
      /var/cache/apk/* \
      /opt/ruby-build \

 # update rubygems
 && gem update --system \

 # don't let rubygems build rdoc docs for gems automatically
 && mkdir -p /usr/local/etc \
 && echo 'gem: --no-rdoc --no-ri' >> /usr/local/etc/gemrc
